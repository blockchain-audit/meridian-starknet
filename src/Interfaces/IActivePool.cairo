
#[starknet::interface]
trait IActivePool<ContractState>{
    // --- Functions ---
    fn sendETH(
        self: @ContractState, _account: ContractAddress, _amount: felt252
    ) ;
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