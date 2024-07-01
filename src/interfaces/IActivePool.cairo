#[starknet::interface]
trait IActivePool {
    use starknet::ContractAddress
    #[external(v0)]
    fn sendSTARK(_account: ContractAddress, _amount: u256);

    #[event(v0)]
    fn BorrowerOperationsAddressChanged(_newBorrowerOperationsAddress: felt252);

    #[event(v0)]
    fn TroveManagerAddressChanged(_newTroveManagerAddress: felt252);

    #[event(v0)]
    fn ActivePoolLUSDDebtUpdated(_LUSDDebt: u256);

    #[event(v0)]
    fn ActivePoolETHBalanceUpdated(_ETH: u256);
}
