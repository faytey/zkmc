use core::debug::PrintTrait;
use snforge_std::{declare, ContractClassTrait, start_prank, CheatTarget};
use cairo_smart_contract::erc20::{IErc20Dispatcher, IErc20DispatcherTrait};
use starknet::{ContractAddress, get_caller_address};

    #[test]
    fn test_name() {
        let contract = declare("ERC20");
        let contract_address = contract.deploy(@array![]).unwrap();
        let dispatcher = IErc20Dispatcher { contract_address };

        let name = dispatcher.get_name();
        assert(name == 'ZKMasterClass', 'Incorrect Name');
    }

    #[test]
    fn test_symbol() {
        let contract = declare("ERC20");
        let contract_address = contract.deploy(@array![]).unwrap();
        let dispatcher = IErc20Dispatcher { contract_address };

        let symbol = dispatcher.get_symbol();
        assert(symbol == 'ZKMC', 'Incorrect Symbol');
    }

    #[test]
    fn test_decimal() {
        let contract = declare("ERC20");
        let contract_address = contract.deploy(@array![]).unwrap();
        let dispatcher = IErc20Dispatcher { contract_address };

        let decimal = dispatcher.get_decimal();
        assert(decimal == 18, 'Incorrect Decimal');
    }

    #[test]
    fn test_total_supply() {
        let contract = declare("ERC20");
        let contract_address = contract.deploy(@array![]).unwrap();
        let dispatcher = IErc20Dispatcher { contract_address };

        let supply = dispatcher.get_total_supply();
        assert(supply == 0, 'Incorrect Supply');
        assert(supply < 1, 'Supply < 1');
    }

    #[test]
    fn mint() {
        let contract = declare("ERC20");
        let contract_address = contract.deploy(@array![]).unwrap();
        let dispatcher = IErc20Dispatcher { contract_address };
        
        let recipient: ContractAddress = 0x03af13f04C618e7824b80b61e141F5b7aeDB07F5CCe3aD16Dbd8A4BE333A3Ffa.try_into().unwrap();
        let amount: u256 = 1000;
        dispatcher.mint(recipient, amount);
        assert(dispatcher.balanceOf(recipient) > 0, 'Mint unsuccessful');
        assert(dispatcher.balanceOf(recipient) == 1000, 'Not 1000');
        assert(dispatcher.get_total_supply() > 0, 'Supply < 0');
        assert(dispatcher.get_total_supply() == 1000, 'Supply < 1000');
    }

     #[test]
    fn test_approve() {
        let contract = declare("ERC20");
        let contract_address = contract.deploy(@array![]).unwrap();
        let dispatcher = IErc20Dispatcher { contract_address };

        let owner = 0x07ab19dfcc6981ad7beba769a71a2d1cdd52b3d8a1484637bbb79f18a170cd51.try_into().unwrap();

        let amount: u256 = 10000;

        let recipient: ContractAddress = 0x03af13f04C618e7824b80b61e141F5b7aeDB07F5CCe3aD16Dbd8A4BE333A3Ffa.try_into().unwrap();
        start_prank(CheatTarget::One(contract_address), owner);
        dispatcher.approve(recipient, amount);
        assert(dispatcher.allowance(owner, recipient) > 0, 'Incorrect Allowance');
    }
    
    #[test]
    fn test_transfer() {
        let contract = declare("ERC20");
        let contract_address = contract.deploy(@array![]).unwrap();
        let dispatcher = IErc20Dispatcher { contract_address };
        let owner = 0x07ab19dfcc6981ad7beba769a71a2d1cdd52b3d8a1484637bbb79f18a170cd51.try_into().unwrap();
        let recipient: ContractAddress = 0x03af13f04C618e7824b80b61e141F5b7aeDB07F5CCe3aD16Dbd8A4BE333A3Ffa.try_into().unwrap();
        let amount: u256 = 10000;
        let amount2: u256 = 5000;
        start_prank(CheatTarget::One(contract_address), owner);
        dispatcher.mint(owner, amount);
        assert(dispatcher.balanceOf(owner) > 0, 'Unsuccessful');
        assert(dispatcher.balanceOf(owner) == amount, 'Not 10000');
        let rec_prev_bal = dispatcher.balanceOf(recipient);
        let transfer = dispatcher.transfer(recipient, amount2);
        assert(dispatcher.balanceOf(owner) < amount, 'Not < 10000');
        assert(dispatcher.balanceOf(owner) == amount2, 'Not 10000');
        assert(dispatcher.balanceOf(recipient) > rec_prev_bal, 'Not equal');
        
    }
