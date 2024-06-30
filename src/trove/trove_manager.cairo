// %lang starknet
use debug::PrintTrait;
use starknet::ContractAddress;
use super ::{IActivePool,IDefaultPool,IPriceFeed}
use super :: {stabilityPool}
use utils::safeMath
import StructTroveManager as structs_trove
//we need to connect this smart contract to safeMath contract 
#[starknet::contract]
mod TroveManager {
    fn batchLiquidateTroves(mut troveArray:<ContractAddress>){
        assert(troveArray.length==0, 'error, Calldata address array must not be empty');
        activePoolCached :IActivePool= structs_trove.ContractsCache.activePool;
        defaultPoolCached :IDefaultPool= structs_trove.ContractsCache.defaultPool;
        priceFeed:IPriceFeed;
        //הממשק  לא מובן למה צריך לדרוס מתנה מטיפוס  
        //מבצע את כל 
        stabilityPoolCached:stabilityPool;
        let mut vars :structs_trove.LocalVariables_OuterLiquidationFunction;
        let mut totals:structs_trove.LiquidationTotals;
        vars.price =priceFeed.fetchPrice();
        //מחזיר את הטוטל LUSD
        vars.LUSDInStabPool = stabilityPoolCached.getTotalLUSDDeposits();
        //who is function _checkRecoveryMode 
        vars.recoveryModeAtStart = _checkRecoveryMode(vars.price);
        if vars.recoveryModeAtStart{
            totals = getTotalFromBatchLiquidate_RecoveryMode(activePoolCached, defaultPoolCached, vars.price, vars.LUSDInStabPool, troveArray);
        }else{
            totals = getTotalsFromBatchLiquidate_NormalMode(activePoolCached, defaultPoolCached, vars.price, vars.LUSDInStabPool, troveArray);
        }
        assert(totals.totalDebtInSequence > 0, "TroveManager: nothing to liquidate");
        stabilityPoolCached.offset(totals.totalDebtToOffset, totals.totalCollToSendToSP);
        redistributeDebtAndColl(activePoolCached, defaultPoolCached, totals.totalDebtToRedistribute, totals.totalCollToRedistribute);
        if (totals.totalCollSurplus > 0) {
            activePoolCached.sendSTARK(ContractAddress(collSurplusPool), totals.totalCollSurplus);
        }
        // Update system snapshots
        updateSystemSnapshots_excludeCollRemainder(activePoolCached, totals.totalCollGasCompensation);
        vars.liquidatedDebt = totals.totalDebtInSequence;
        vars.liquidatedColl =
            totals.totalCollInSequence.sub(totals.totalCollGasCompensation).sub(totals.totalCollSurplus);
        emit Liquidation(
            vars.liquidatedDebt, vars.liquidatedColl, totals.totalCollGasCompensation, totals.totalLUSDGasCompensation
        );
        self.emit(Liquidation { _liquidatedDebt: vars.liquidatedDebt, _liquidatedColl:  vars.liquidatedColl,_LUSDGasCompensation: totals.totalLUSDGasCompensation});
        _liquidatedDebt: felt252,
        _liquidatedColl:felt252,
        _collGasCompensation:felt252,
        _LUSDGasCompensation:felt252,
        // Send gas compensation to caller
        // sendGasCompensation(
        //     activePoolCached, msg.sender, totals.totalLUSDGasCompensation, totals.totalCollGasCompensation
        // );
    }
    fn getTotalFromBatchLiquidate_RecoveryMode(
        activePool:IActivePool,
        defaultPool:IDefaultPool,
        price:felt252,
        LUSDInStabPool:felt252,
        mut troveArray:<ContractAddress>
    ) internal returns (mut totals:LiquidationTotals) {}

    fn getTotalsFromBatchLiquidate_NormalMode(
        activePool:IActivePool,
        defaultPool:IDefaultPool,
        price:felt252,
        LUSDInStabPool:felt252,
        mut troveArray:<ContractAddress>
    ) internal returns (mut totals:LiquidationTotals) {}

    function redistributeDebtAndColl(activePool:IActivePool, defaultPool:IDefaultPool, debt:felt252, coll:felt252)
        internal
    {}
}