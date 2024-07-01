use starknet::ContractAddress;
use openzeppelin::token::erc20::{IERC20};

#[starknet::interface]
trait ILQTYToken {
    // Functions 
    #[external]
    fn getETH() -> felt252;
    #[external]
    fn getLUSDDebt() -> felt252;
    #[external]
    fn increaseLUSDDebt(amount: felt252);
    #[external]
    fn decreaseLUSDDebt(amount: felt252);
}
#[event]
#[derive(Drop, starknet::Event)]
enum Event {
    StoredName: StoredName,
}
#[event]
#[derive(Drop, starknet::Event)]
enum Event {
    ETHBalanceUpdated: ETHBalanceUpdated,
    LUSDBalanceUpdated: LUSDBalanceUpdated,
    ActivePoolAddressChanged: ActivePoolAddressChanged,
    DefaultPoolAddressChanged: DefaultPoolAddressChanged,
    EtherSent: EtherSent,
}
#[derive(Drop, starknet::Event)]
struct ETHBalanceUpdated {
    _newBalance: felt252,
}
#[derive(Drop, starknet::Event)]
struct LUSDBalanceUpdated {
    _newBalance: felt252,
}
#[derive(Drop, starknet::Event)]
struct ActivePoolAddressChanged {
    _newActivePoolAddress: felt252,
}
#[derive(Drop, starknet::Event)]
struct DefaultPoolAddressChanged {
    _newDefaultPoolAddress: felt252,
}
#[derive(Drop, starknet::Event)]
struct StabilityPoolAddressChanged {
    _newStabilityPoolAddress: felt252,
}
#[derive(Drop, starknet::Event)]
struct EtherSent {
    _toAddress: felt252,
    amount: felt252,
}
