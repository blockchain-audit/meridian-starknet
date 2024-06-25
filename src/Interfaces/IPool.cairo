#[starknet::interface] :
trait ILQTYToken { 
    use openzeppelin::token::erc20::{IERC20};
    use starknet::ContractAddress;
    // Functions 
    @external
    fn getETH()->(felt252);
    @external
    fn getLUSDDebt()->(felt252);
    @external
    fn increaseLUSDDebt(amount:felt252);
    @external
    fn decreaseLUSDDebt(amount:felt252);

    //Events
    @event
    fn ETHBalanceUpdated(_newBalance:felt252);
    @event
    fn LUSDBalanceUpdated(_newBalance:felt252)
    @event
    fn ActivePoolAddressChanged(_newActivePoolAddress:felt252)
    @event
    fn DefaultPoolAddressChanged(_newDefaultPoolAddress:felt252) 
    @event
    fn StabilityPoolAddressChanged(_newStabilityPoolAddress:felt252)
    @event 
    fn EtherSent(_toAddress:felt252,amount:felt252 );
    }










