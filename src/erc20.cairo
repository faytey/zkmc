use starknet::{ContractAddress, get_caller_address, contract_address_const};

#[starknet::interface]
trait erc20Traits<TContractState> {
    fn approve(ref self: TContractState, spender: ContractAddress, amount: u256) -> bool;
    fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;
    fn balanceOf(self: @TContractState, address: ContractAddress) -> u256;
    fn mint(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;
    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;
}

#[starknet::contract]
mod ERC20 {
    use starknet::{ContractAddress, get_caller_address, get_contract_address};
    use cairo_smart_contract::erc20::erc20Traits;

    #[storage]
    struct Storage {
        balances: LegacyMap::<ContractAddress, u256>,
        allowances: LegacyMap::<(ContractAddress, ContractAddress), u256>,
        token_name: felt252,
        symbol: felt252,
        decimal: u8,
        total_supply: u256,
        owner: ContractAddress
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Mint: Mint
    }

    #[derive(Drop, starknet::Event)]
    struct Mint {
        #[key]
        recipient: ContractAddress,
        amount: u256,
    }

    #[constructor]
    fn constructor(ref self: ContractState, deployer: ContractAddress) {
    
        self.token_name.write('ZKMasterClass');
        self.symbol.write('ZKMC');
        self.decimal.write(18);
        self.owner.write(deployer);
    }

    #[abi(embed_v0)]
    impl erc20Impl of erc20Traits<ContractState>{

        fn approve(ref self: ContractState, spender: ContractAddress, amount: u256) -> bool {
            self.allowances.write((get_caller_address(), spender), amount);
            return true;
        }

        fn allowance(self: @ContractState, owner: ContractAddress, spender: ContractAddress) -> u256 {
            let allowance: u256 = self.allowances.read((owner,spender));
            allowance
        }

        fn balanceOf(self: @ContractState, address: ContractAddress) -> u256 {
            let balance: u256 = self.balances.read(address);
            balance
        }

        fn mint(ref self: ContractState, recipient: ContractAddress, amount: u256) -> bool {
            let prev_total = self.total_supply.read();
            self.total_supply.write(prev_total + amount);
            self.balances.write(recipient, amount);
            self.emit(Mint {recipient: recipient, amount: amount});
            true
        }
        
        fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) -> bool {
            let prev_balance = self.balances.read(get_caller_address());
            let rec_old_balance = self.balances.read(recipient);
            assert(prev_balance >= amount, 'Insufficient');
            self.balances.write(get_caller_address(), prev_balance - amount);
            self.balances.write(recipient, rec_old_balance + amount);
            assert(self.balances.read(recipient) > rec_old_balance, 'Unsuccessful tx');
            true
        }
    }
    
}