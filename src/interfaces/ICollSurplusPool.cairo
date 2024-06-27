
#[starknet::interface]
trait ICollSurplusPool {


    #[external(v0)]
    fn setAddresses(
    _borrowerOperationsAddress: felt252,
    _troveManagerAddress: felt252,
    _activePoolAddress: felt252
    );

    #[view]
    #[read_only]
    fn getETH() -> u256;

    #[view]
    #[read_only]
    fn getCollateral(_account: felt252) -> u256;

    #[external(v0)]
    fn accountSurplus(_account: felt252, _amount: u256);

    #[external(v0)]
    fn claimColl(_account: felt252);


    #[event(v0)]
    fn BorrowerOperationsAddressChanged(_newBorrowerOperationsAddress: felt252);

    #[event(v0)]
    fn TroveManagerAddressChanged(_newTroveManagerAddress: felt252);

    #[event(v0)]
    fn ActivePoolAddressChanged(_newActivePoolAddress: felt252);

    #[event(v0)]
    fn CollBalanceUpdated(_account: felt252, _newBalance: u256);

    #[event(v0)]
    fn EtherSent(_to: felt252, _amount: u256);



}

