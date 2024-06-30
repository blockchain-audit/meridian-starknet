#[starknet::interface] :
trait IPool { 
    use openzeppelin::token::erc20::{IERC20};
    use starknet::ContractAddress;
    // Functions 
    #[external]
    fn getETH()->(felt252);
    #[external]
    fn getLUSDDebt()->(felt252);
    #[external]
    fn increaseLUSDDebt(amount:felt252);
    #[external]
    fn decreaseLUSDDebt(amount:felt252);

    //Events
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ETHBalanceUpdated: ETHBalanceUpdated,
        LUSDBalanceUpdated:LUSDBalanceUpdated,
        ActivePoolAddressChanged:ActivePoolAddressChanged,
        DefaultPoolAddressChanged:DefaultPoolAddressChanged,
        StabilityPoolAddressChanged:StabilityPoolAddressChanged,
        EtherSent:EtherSent,
    }
    #[derive(Drop, starknet::Event)]
    struct ETHBalanceUpdated{
        _newBalance: felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct LUSDBalanceUpdated{
        _newBalance: felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct ActivePoolAddressChanged{
        _newActivePoolAddress: felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct DefaultPoolAddressChanged{
        _newDefaultPoolAddress: felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct StabilityPoolAddressChanged{
        _newStabilityPoolAddress: felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct EtherSent{
        _toAddress: felt252,
        amount:felt252,
    }
}










