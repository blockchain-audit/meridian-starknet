use starknet::ContractAddress;
#[starknet::interface]
trait IStabilityPool {
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        StabilityPoolETHBalanceUpdated: StabilityPoolETHBalanceUpdate,
        StabilityPoolLUSDBalanceUpdated: StabilityPoolLUSDBalance,
        
        BorrowerOperationAddressChanged: BorrowerOperationAddressChanged
    }

    #[derive(Drop, starknet::Event)]
    struct StabilityPoolETHBalanceUpdate {
        _newBalance: u256
    }
    #[derive(Drop, starknet::Event)]
    struct StabilityPoolLUSDBalanceUpdated {
        _newBalance: u256
    }
    #[derive(Drop, starknet:: Event)]
    struct BorrowerOperationAddressChanged {
        _operationAddress: ContractAddress
    }
}