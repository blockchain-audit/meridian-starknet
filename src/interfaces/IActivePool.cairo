
#[starknet::interface]
trait IActivePool<ContractState>{
    use starknet::ContractAddress
    // --- Functions ---
    fn sendSTARK(_account: ContractAddress, _amount: u256);

}
// --- Events ---
#[event]
#[derive(Drop, starknet::Event)]
enum Event {
    BorrowerOperationsAddressChanged: BorrowerOperationsAddressChanged,
    TroveManagerAddressChanged: TroveManagerAddressChanged,
    ActivePoolLUSDDebtUpdated: ActivePoolLUSDDebtUpdated,
    ActivePoolETHBalanceUpdated: ActivePoolETHBalanceUpdated,
}

#[derive(Drop, starknet::Event)]
struct BorrowerOperationsAddressChanged {
    newBorrowerOperationsAddress: ContractAddress
}

#[derive(Drop, starknet::Event)]
struct TroveManagerAddressChanged {
    newTroveManagerAddress: ContractAddress
}

#[derive(Drop, starknet::Event)]
struct ActivePoolLUSDDebtUpdated {
    LUSDDebt: felt252
}

#[derive(Drop, starknet::Event)]
struct ActivePoolETHBalanceUpdated {
    ETH: felt252
}