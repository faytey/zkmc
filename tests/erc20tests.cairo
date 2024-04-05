use core::debug::PrintTrait;
use snforge_std::{declare, ContractClassTrait};
// use core::option::OptionTrait;
// use core::traits::TryInto;
// use core::array::ArrayTrait;
use cairo_smart_contract::erc20::{IErc20Dispatcher, IErc20DispatcherTrait};
use starknet::{ContractAddress};

    #[test]
    fn test_mint() {
        let contract = declare("ERC20");
        let contract_address = contract.deploy(@array![]).unwrap();
        let dispatcher = IErc20Dispatcher { contract_address };

        let recipient: ContractAddress = 0x03af13f04C618e7824b80b61e141F5b7aeDB07F5CCe3aD16Dbd8A4BE333A3Ffa.try_into().unwrap();
        let amount: u256 = 1000;
        dispatcher.mint(recipient, amount);
        assert(dispatcher.balanceOf(recipient) > 0, 'Mint unsuccessful');
        assert(dispatcher.balanceOf(recipient) == 1000, 'Not 1000');
        'am a mint'.print();
    }

