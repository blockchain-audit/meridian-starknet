
#[starknet::interface]
trait IActivePool {
    #[external(v0)]
    fn sendETH(_account: felt252, _amount: u256);

    #[event(v0)]
    fn BorrowerOperationsAddressChanged(_newBorrowerOperationsAddress: felt252);

    #[event(v0)]
    fn TroveManagerAddressChanged(_newTroveManagerAddress: felt252);

    #[event(v0)]
    fn ActivePoolLUSDDebtUpdated(_LUSDDebt: u256);

    #[event(v0)]
    fn ActivePoolETHBalanceUpdated(_ETH: u256);
}
