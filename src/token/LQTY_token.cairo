use starknet::ContractAddress;

#[starknet::contract]
mod LQTYToken {
    
    #[storge]
    struct Storage{
        _NAME:felt252,
        _SYMBOL:felt252,
        _VERSION:felt252,
        _DECIMALS:felt252,
        _balances:LegacyMap:: <contractAddress, felt252>,
        _allowance:LegacyMap::<(ContractAddress,ContractAddress),felt252>,
        _totalSupply:felt252,

    }


    #[constructor]
    fn constructor(ref self: TContractState) {
        
    }

    #[external(v0)]
    impl ILQTYTokenImp of super :: ILQTYToken<TContractState> {

        fn balanceOf(self:@TContractState , account:contractAddress) -> felt252{
            self.balanceOf.read(acount);
        }
    }
    

}