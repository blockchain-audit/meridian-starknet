use starknet::ContractAddress;
use super::IPool;

#[starknet::interface]
trait IDefaultPool<TContractState> : IPool {


        // --- Events ---
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        TroveManagerAddressChanged: TroveManagerAddressChanged,
        DefaultPoolLUSDDebtUpdated: DefaultPoolLUSDDebtUpdated,
        DefaultPoolSTARKBalanceUpdated: DefaultPoolSTARKBalanceUpdated
    }

    #[derive(Drop, starknet::Event)]
    struct TroveManagerAddressChanged {
        #[key]
        _newTroveManagerAddress: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct DefaultPoolLUSDDebtUpdated {
        #[key]
        _LUSDDebt: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct DefaultPoolSTARKBalanceUpdated {
        #[key]
        _STARK: u256,
    }

    fn sendSTARKToActivePool(ref self: TContractState, _amount: u256) external;

}
