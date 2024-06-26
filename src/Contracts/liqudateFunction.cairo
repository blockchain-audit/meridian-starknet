/     // --- Trove Liquidation functions ---

//     // Single liquidation function. Closes the trove if its ICR is lower than the minimum collateral ratio.
//     function liquidate(address _borrower) external override {
//         _requireTroveIsActive(_borrower);

//         address[] memory borrowers = new address[](1);
//         borrowers[0] = _borrower;
//         batchLiquidateTroves(borrowers);
//     }

//     // --- Inner single liquidation functions ---

//     // Liquidate one trove, in Normal Mode.
//     function _liquidateNormalMode(
//         IActivePool _activePool,
//         IDefaultPool _defaultPool,
//         address _borrower,
//         uint256 _LUSDInStabPool
//     ) internal returns (LiquidationValues memory singleLiquidation) {
//         LocalVariables_InnerSingleLiquidateFunction memory vars;

//         (
//             singleLiquidation.entireTroveDebt,
//             singleLiquidation.entireTroveColl,
//             vars.pendingDebtReward,
//             vars.pendingCollReward
//         ) = getEntireDebtAndColl(_borrower);

//         _movePendingTroveRewardsToActivePool(_activePool, _defaultPool, vars.pendingDebtReward, vars.pendingCollReward);
//         _removeStake(_borrower);

//         singleLiquidation.collGasCompensation = _getCollGasCompensation(singleLiquidation.entireTroveColl);
//         singleLiquidation.LUSDGasCompensation = LUSD_GAS_COMPENSATION;
//         uint256 collToLiquidate = singleLiquidation.entireTroveColl.sub(singleLiquidation.collGasCompensation);

//         (
//             singleLiquidation.debtToOffset,
//             singleLiquidation.collToSendToSP,
//             singleLiquidation.debtToRedistribute,
//             singleLiquidation.collToRedistribute
//         ) = _getOffsetAndRedistributionVals(singleLiquidation.entireTroveDebt, collToLiquidate, _LUSDInStabPool);

//         _closeTrove(_borrower, Status.closedByLiquidation);
//         emit TroveLiquidated(
//             _borrower,
//             singleLiquidation.entireTroveDebt,
//             singleLiquidation.entireTroveColl,
//             TroveManagerOperation.liquidateInNormalMode
//         );
//         emit TroveUpdated(_borrower, 0, 0, 0, TroveManagerOperation.liquidateInNormalMode);
//         return singleLiquidation;
//     }

//     // Liquidate one trove, in Recovery Mode.
//     function _liquidateRecoveryMode(
//         IActivePool _activePool,
//         IDefaultPool _defaultPool,
//         address _borrower,
//         uint256 _ICR,
//         uint256 _LUSDInStabPool,
//         uint256 _TCR,
//         uint256 _price
//     ) internal returns (LiquidationValues memory singleLiquidation) {
//         LocalVariables_InnerSingleLiquidateFunction memory vars;
//         if (TroveOwners.length <= 1) return singleLiquidation; // don't liquidate if last trove
//         (
//             singleLiquidation.entireTroveDebt,
//             singleLiquidation.entireTroveColl,
//             vars.pendingDebtReward,
//             vars.pendingCollReward
//         ) = getEntireDebtAndColl(_borrower);

//         singleLiquidation.collGasCompensation = _getCollGasCompensation(singleLiquidation.entireTroveColl);
//         singleLiquidation.LUSDGasCompensation = LUSD_GAS_COMPENSATION;
//         vars.collToLiquidate = singleLiquidation.entireTroveColl.sub(singleLiquidation.collGasCompensation);

//         // If ICR <= 100%, purely redistribute the Trove across all active Troves
//         if (_ICR <= _100pct) {
//             _movePendingTroveRewardsToActivePool(
//                 _activePool, _defaultPool, vars.pendingDebtReward, vars.pendingCollReward
//             );
//             _removeStake(_borrower);

//             singleLiquidation.debtToOffset = 0;
//             singleLiquidation.collToSendToSP = 0;
//             singleLiquidation.debtToRedistribute = singleLiquidation.entireTroveDebt;
//             singleLiquidation.collToRedistribute = vars.collToLiquidate;

//             _closeTrove(_borrower, Status.closedByLiquidation);
//             emit TroveLiquidated(
//                 _borrower,
//                 singleLiquidation.entireTroveDebt,
//                 singleLiquidation.entireTroveColl,
//                 TroveManagerOperation.liquidateInRecoveryMode
//             );
//             emit TroveUpdated(_borrower, 0, 0, 0, TroveManagerOperation.liquidateInRecoveryMode);

//             // If 100% < ICR < MCR, offset as much as possible, and redistribute the remainder
//         } else if ((_ICR > _100pct) && (_ICR < MCR)) {
//             _movePendingTroveRewardsToActivePool(
//                 _activePool, _defaultPool, vars.pendingDebtReward, vars.pendingCollReward
//             );
//             _removeStake(_borrower);

//             (
//                 singleLiquidation.debtToOffset,
//                 singleLiquidation.collToSendToSP,
//                 singleLiquidation.debtToRedistribute,
//                 singleLiquidation.collToRedistribute
//             ) = _getOffsetAndRedistributionVals(
//                 singleLiquidation.entireTroveDebt, vars.collToLiquidate, _LUSDInStabPool
//             );

//             _closeTrove(_borrower, Status.closedByLiquidation);
//             emit TroveLiquidated(
//                 _borrower,
//                 singleLiquidation.entireTroveDebt,
//                 singleLiquidation.entireTroveColl,
//                 TroveManagerOperation.liquidateInRecoveryMode
//             );
//             emit TroveUpdated(_borrower, 0, 0, 0, TroveManagerOperation.liquidateInRecoveryMode);
//             /*
//         * If 110% <= ICR < current TCR (accounting for the preceding liquidations in the current sequence)
//         * and there is LUSD in the Stability Pool, only offset, with no redistribution,
//         * but at a capped rate of 1.1 and only if the whole debt can be liquidated.
//         * The remainder due to the capped rate will be claimable as collateral surplus.
//         */
//         } else if ((_ICR >= MCR) && (_ICR < _TCR) && (singleLiquidation.entireTroveDebt <= _LUSDInStabPool)) {
//             _movePendingTroveRewardsToActivePool(
//                 _activePool, _defaultPool, vars.pendingDebtReward, vars.pendingCollReward
//             );
//             assert(_LUSDInStabPool != 0);

//             _removeStake(_borrower);
//             singleLiquidation =
//                 _getCappedOffsetVals(singleLiquidation.entireTroveDebt, singleLiquidation.entireTroveColl, _price);

//             _closeTrove(_borrower, Status.closedByLiquidation);
//             if (singleLiquidation.collSurplus > 0) {
//                 collSurplusPool.accountSurplus(_borrower, singleLiquidation.collSurplus);
//             }

//             emit TroveLiquidated(
//                 _borrower,
//                 singleLiquidation.entireTroveDebt,
//                 singleLiquidation.collToSendToSP,
//                 TroveManagerOperation.liquidateInRecoveryMode
//             );
//             emit TroveUpdated(_borrower, 0, 0, 0, TroveManagerOperation.liquidateInRecoveryMode);
//         } else {
//             // if (_ICR >= MCR && ( _ICR >= _TCR || singleLiquidation.entireTroveDebt > _LUSDInStabPool))
//             LiquidationValues memory zeroVals;
//             return zeroVals;
//         }

//         return singleLiquidation;
//     }

//     /* In a full liquidation, returns the values for a trove's coll and debt to be offset, and coll and debt to be
//     * redistributed to active troves.
//     */
//     function _getOffsetAndRedistributionVals(uint256 _debt, uint256 _coll, uint256 _LUSDInStabPool)
//         internal
//         pure
//         returns (uint256 debtToOffset, uint256 collToSendToSP, uint256 debtToRedistribute, uint256 collToRedistribute)
//     {
//         if (_LUSDInStabPool > 0) {
//             /*
//         * Offset as much debt & collateral as possible against the Stability Pool, and redistribute the remainder
//         * between all active troves.
//         *
//         *  If the trove's debt is larger than the deposited LUSD in the Stability Pool:
//         *
//         *  - Offset an amount of the trove's debt equal to the LUSD in the Stability Pool
//         *  - Send a fraction of the trove's collateral to the Stability Pool, equal to the fraction of its offset debt
//         *
//         */
//             debtToOffset = LiquityMath._min(_debt, _LUSDInStabPool);
//             collToSendToSP = _coll.mul(debtToOffset).div(_debt);
//             debtToRedistribute = _debt.sub(debtToOffset);
//             collToRedistribute = _coll.sub(collToSendToSP);
//         } else {
//             debtToOffset = 0;
//             collToSendToSP = 0;
//             debtToRedistribute = _debt;
//             collToRedistribute = _coll;
//         }
//     }
function liquidateTroves(uint256 _n) external override {
    //         ContractsCache memory contractsCache = ContractsCache(
    //             activePool,
    //             defaultPool,
    //             ILUSDToken(address(0)),
    //             ILQTYStaking(address(0)),
    //             sortedTroves,
    //             ICollSurplusPool(address(0)),
    //             address(0)
    //         );
    //         IStabilityPool stabilityPoolCached = stabilityPool;
    
    //         LocalVariables_OuterLiquidationFunction memory vars;
    
    //         LiquidationTotals memory totals;
    
    //         vars.price = priceFeed.fetchPrice();
    //         vars.LUSDInStabPool = stabilityPoolCached.getTotalLUSDDeposits();
    //         vars.recoveryModeAtStart = _checkRecoveryMode(vars.price);
    
    //         // Perform the appropriate liquidation sequence - tally the values, and obtain their totals
    //         if (vars.recoveryModeAtStart) {
    //             totals =
    //                 _getTotalsFromLiquidateTrovesSequence_RecoveryMode(contractsCache, vars.price, vars.LUSDInStabPool, _n);
    //         } else {
    //             // if !vars.recoveryModeAtStart
    //             totals = _getTotalsFromLiquidateTrovesSequence_NormalMode(
    //                 contractsCache.activePool, contractsCache.defaultPool, vars.price, vars.LUSDInStabPool, _n
    //             );
    //         }
    
    //         require(totals.totalDebtInSequence > 0, "TroveManager: nothing to liquidate");
    
    //         // Move liquidated ETH and LUSD to the appropriate pools
    //         stabilityPoolCached.offset(totals.totalDebtToOffset, totals.totalCollToSendToSP);
    //         _redistributeDebtAndColl(
    //             contractsCache.activePool,
    //             contractsCache.defaultPool,
    //             totals.totalDebtToRedistribute,
    //             totals.totalCollToRedistribute
    //         );
    //         if (totals.totalCollSurplus > 0) {
    //             contractsCache.activePool.sendETH(address(collSurplusPool), totals.totalCollSurplus);
    //         }
    
    //         // Update system snapshots
    //         _updateSystemSnapshots_excludeCollRemainder(contractsCache.activePool, totals.totalCollGasCompensation);
    
    //         vars.liquidatedDebt = totals.totalDebtInSequence;
    //         vars.liquidatedColl =
    //             totals.totalCollInSequence.sub(totals.totalCollGasCompensation).sub(totals.totalCollSurplus);
    //         emit Liquidation(
    //             vars.liquidatedDebt, vars.liquidatedColl, totals.totalCollGasCompensation, totals.totalLUSDGasCompensation
    //         );
    
    //         // Send gas compensation to caller
    //         _sendGasCompensation(
    //             contractsCache.activePool, msg.sender, totals.totalLUSDGasCompensation, totals.totalCollGasCompensation
    //         );
    //     }
