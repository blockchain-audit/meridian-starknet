use starknet::ContractAddress;

#[starknet::interface]
trait ICollSurplusPool {
    // --- Contract setters ---
    #[external(v0)]
    fn setAddresses(
        _borrowerOperationsAddress: ContractAddress,
        _troveManagerAddress: ContractAddress,
        _activePoolAddress: ContractAddress
    );

    #[external(v0)]
    #[view]
    fn getETH() -> u256;

    #[external(v0)]
    #[view]
    fn getCollateral(_account: ContractAddress) -> u256;

    #[external(v0)]
    fn accountSurplus(_account: ContractAddress, _amount: u256);

    #[external(v0)]
    fn claimColl(_account: ContractAddress);
}


#[event]
#[derive(Drop, starknet::Event)]
enum Event {
    BorrowerOperationsAddressChanged: BorrowerOperationsAddressChanged,
    TroveManagerAddressChanged: TroveManagerAddressChanged,
    ActivePoolAddressChanged: ActivePoolAddressChanged,
    CollBalanceUpdated: CollBalanceUpdated,
    EtherSent: EtherSent
}

#[derive(Drop, starknet::Event)]
struct BorrowerOperationsAddressChanged {
    _newBorrowerOperationsAddress: ContractAddress
}

#[derive(Drop, starknet::Event)]
struct TroveManagerAddressChanged {
    _newTroveManagerAddress: ContractAddress
}

#[derive(Drop, starknet::Event)]
struct ActivePoolAddressChanged {
    _newActivePoolAddress: ContractAddress
}

#[derive(Drop, starknet::Event)]
struct CollBalanceUpdated {
    _newActivePoolAddress: ContractAddress
}

#[derive(Drop, starknet::Event)]
struct EtherSent {
    _account: ContractAddress,
    _newBalance: u256
}

#[derive(Drop, starknet::Event)]
struct EtherSent {
    _to: ContractAddress,
    _amount: u256
}

