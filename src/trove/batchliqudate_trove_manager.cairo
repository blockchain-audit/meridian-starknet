
use debug::PrintTrait;
#[starknet::contract]
mod BetchLiqudateTrove {


fn valiedBetchLiqudateTrove(){
    if _troveArray.length == 0 {
        'TroveManager: Calldata address array must not be empty'.print();
        assert(x != y, 'error, x is equal to y');

    }
}
}
function batchLiquidateTroves(address[] memory _troveArray) public override {
    require(_troveArray.length != 0, "TroveManager: Calldata address array must not be empty");

    IActivePool activePoolCached = activePool;
    IDefaultPool defaultPoolCached = defaultPool;
    IStabilityPool stabilityPoolCached = stabilityPool;

    LocalVariables_OuterLiquidationFunction memory vars;
    LiquidationTotals memory totals;

    vars.price = priceFeed.fetchPrice();
    vars.LUSDInStabPool = stabilityPoolCached.getTotalLUSDDeposits();
    vars.recoveryModeAtStart = _checkRecoveryMode(vars.price);

    // Perform the appropriate liquidation sequence - tally values and obtain their totals.
    if (vars.recoveryModeAtStart) {
        totals = _getTotalFromBatchLiquidate_RecoveryMode(
            activePoolCached, defaultPoolCached, vars.price, vars.LUSDInStabPool, _troveArray
        );
    } else {
        //  if !vars.recoveryModeAtStart
        totals = _getTotalsFromBatchLiquidate_NormalMode(
            activePoolCached, defaultPoolCached, vars.price, vars.LUSDInStabPool, _troveArray
        );
    }

    require(totals.totalDebtInSequence > 0, "TroveManager: nothing to liquidate");

    // Move liquidated ETH and LUSD to the appropriate pools
    stabilityPoolCached.offset(totals.totalDebtToOffset, totals.totalCollToSendToSP);
    _redistributeDebtAndColl(
        activePoolCached, defaultPoolCached, totals.totalDebtToRedistribute, totals.totalCollToRedistribute
    );
    if (totals.totalCollSurplus > 0) {
        activePoolCached.sendETH(address(collSurplusPool), totals.totalCollSurplus);
    }

    // Update system snapshots
    _updateSystemSnapshots_excludeCollRemainder(activePoolCached, totals.totalCollGasCompensation);

    vars.liquidatedDebt = totals.totalDebtInSequence;
    vars.liquidatedColl =
        totals.totalCollInSequence.sub(totals.totalCollGasCompensation).sub(totals.totalCollSurplus);
    emit Liquidation(
        vars.liquidatedDebt, vars.liquidatedColl, totals.totalCollGasCompensation, totals.totalLUSDGasCompensation
    );

    // Send gas compensation to caller
    _sendGasCompensation(
        activePoolCached, msg.sender, totals.totalLUSDGasCompensation, totals.totalCollGasCompensation
    );
}
