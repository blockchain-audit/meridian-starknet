

// %lang starknet
use debug::PrintTrait;
use starknet::ContractAddress;
use super ::{IActivePool,IDefaultPool,IStabilityPool}
import StructTroveManager as structs_trove
#[starknet::contract]
mod TroveManager {
    fn batchLiquidateTroves(mut troveArray:<ContractAddress>){
        assert(troveArray.length==0, 'error, Calldata address array must not be empty');
        activePoolCached :IActivePool= structs_trove.ContractsCache.activePool;
        defaultPoolCached :IDefaultPool= structs_trove.ContractsCache.defaultPool;
        stabilityPoolCached:IStabilityPool = structs_trove.ContractsCache.stabilityPool;
    }
}