function _getTotalsFromLiquidateTrovesSequence_RecoveryMode(
    //         ContractsCache memory _contractsCache,
    //         uint256 _price,
    //         uint256 _LUSDInStabPool,
    //         uint256 _n
    //     ) internal returns (LiquidationTotals memory totals) {
    //         LocalVariables_LiquidationSequence memory vars;
    //         LiquidationValues memory singleLiquidation;
    
    //         vars.remainingLUSDInStabPool = _LUSDInStabPool;
    //         vars.backToNormalMode = false;
    //         vars.entireSystemDebt = getEntireSystemDebt();
    //         vars.entireSystemColl = getEntireSystemColl();
    
    //         vars.user = _contractsCache.sortedTroves.getLast();
    //         address firstUser = _contractsCache.sortedTroves.getFirst();
    //         for (vars.i = 0; vars.i < _n && vars.user != firstUser; vars.i++) {
    //             // we need to cache it, because current user is likely going to be deleted
    //             address nextUser = _contractsCache.sortedTroves.getPrev(vars.user);
    
    //             vars.ICR = getCurrentICR(vars.user, _price);
    
    //             if (!vars.backToNormalMode) {
    //                 // Break the loop if ICR is greater than MCR and Stability Pool is empty
    //                 if (vars.ICR >= MCR && vars.remainingLUSDInStabPool == 0) break;
    
    //                 uint256 TCR = LiquityMath._computeCR(vars.entireSystemColl, vars.entireSystemDebt, _price);
    
    //                 singleLiquidation = _liquidateRecoveryMode(
    //                     _contractsCache.activePool,
    //                     _contractsCache.defaultPool,
    //                     vars.user,
    //                     vars.ICR,
    //                     vars.remainingLUSDInStabPool,
    //                     TCR,
    //                     _price
    //                 );
    
    //                 // Update aggregate trackers
    //                 vars.remainingLUSDInStabPool = vars.remainingLUSDInStabPool.sub(singleLiquidation.debtToOffset);
    //                 vars.entireSystemDebt = vars.entireSystemDebt.sub(singleLiquidation.debtToOffset);
    //                 vars.entireSystemColl = vars.entireSystemColl.sub(singleLiquidation.collToSendToSP).sub(
    //                     singleLiquidation.collGasCompensation
    //                 ).sub(singleLiquidation.collSurplus);
    
    //                 // Add liquidation values to their respective running totals
    //                 totals = _addLiquidationValuesToTotals(totals, singleLiquidation);
    
    //                 vars.backToNormalMode =
    //                     !_checkPotentialRecoveryMode(vars.entireSystemColl, vars.entireSystemDebt, _price);
    //             } else if (vars.backToNormalMode && vars.ICR < MCR) {
    //                 singleLiquidation = _liquidateNormalMode(
    //                     _contractsCache.activePool, _contractsCache.defaultPool, vars.user, vars.remainingLUSDInStabPool
    //                 );
    
    //                 vars.remainingLUSDInStabPool = vars.remainingLUSDInStabPool.sub(singleLiquidation.debtToOffset);
    
    //                 // Add liquidation values to their respective running totals
    //                 totals = _addLiquidationValuesToTotals(totals, singleLiquidation);
    //             } else {
    //                 break;
    //             } // break if the loop reaches a Trove with ICR >= MCR
    
    //             vars.user = nextUser;
    //         }
    //     }
    