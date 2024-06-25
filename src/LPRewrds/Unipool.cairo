use openzeppelin::token::erc20::{IERC20};

use starknet::ContractAddress;

use interfaces::{ILPTokenWrapper};

#[starknet::contract]
mod LPTokenWrapper {

    use starknet::{ get_contract_address, get_caller_address, storage_access::StorageBaseAddress };

    #[storage]
    struct Storage {
        _totalSupply: u256,
        _balances: LegacyMap::<felt, u256>,
        uniToken: IERC20
    }

    #[abi(embed_v0)]
    impl LPTokenWrapper of super::ILPTokenWrapper<ContractState> {
        fn totalSupply() -> u256 {
            self._totalSupply.read();
        }

        fn balanceOf(account: felt) -> u256 {
            self._balances.read(account);
        }

        fn stake(amount: u256) {
            self._totalSupply.write(totalSupply() + amount);
            let sender: felt = get_caller_address();
            self._balances.write(balanceOf(sender) + amount);
            uniToken.transferFrom(sender, get_contract_address(), amount);
        }

        fn withdraw(amount: u256) {
            self._totalSupply.write(totalSupply() - amount);
            let recipient: felt = get_caller_address();
            self._balances.write(balanceOf(recipient) - amount);
            uniToken.transfer(recipient, amount);
        }
    }
}