use starknet::ContractAddress;

fn _getTotalsFromLiquidateTrovesSequence_RecoveryMode(_contractsCache:ContractsCache //memory
                   ,mut _price:u256, mut _LUSDInStabPool:u256, mut _n:u256 )-> totals:LiquidationTotals{ //memory

        mut vars:LocalVariables_LiquidationSequence;//memory
        mut singleLiquidation:LiquidationValues;//memory

        vars.remainingLUSDInStabPool = _LUSDInStabPool;
        vars.backToNormalMode = false;
        vars.entireSystemDebt = getEntireSystemDebt();
        vars.entireSystemColl = getEntireSystemColl();

        vars.user = _contractsCache.sortedTroves.getLast();

        let mut firstUser:ContractAddress = _contractsCache.sortedTroves.getFirst();
        vars.i = 0;
        loop{
                if vars.i > _n || vars.user == firstUser {

                    break();
                }
             
                let mut nextUser:ContractAddress = _contractsCache.sortedTroves.getPrev(vars.user);

                vars.ICR = getCurrentICR(vars.user, _price);

                if !vars.backToNormalMode {
                   
                    if vars.ICR >= MCR && vars.remainingLUSDInStabPool == 0{
                        
                        break;
                    } 

                    let mut TCR:u256 = LiquityMath._computeCR(vars.entireSystemColl, vars.entireSystemDebt, _price);

                    singleLiquidation = _liquidateRecoveryMode(
                        _contractsCache.activePool,
                        _contractsCache.defaultPool,
                        vars.user,
                        vars.ICR,
                        vars.remainingLUSDInStabPool,
                        TCR,
                        _price
                    );

                    // Update aggregate trackers
                    vars.remainingLUSDInStabPool = vars.remainingLUSDInStabPool.sub(singleLiquidation.debtToOffset);
                    vars.entireSystemDebt = vars.entireSystemDebt.sub(singleLiquidation.debtToOffset);
                    vars.entireSystemColl = vars.entireSystemColl.sub(singleLiquidation.collToSendToSP).sub(
                        singleLiquidation.collGasCompensation
                    ).sub(singleLiquidation.collSurplus);

                    // Add liquidation values to their respective running totals
                    totals = _addLiquidationValuesToTotals(totals, singleLiquidation);

                    vars.backToNormalMode =
                        !_checkPotentialRecoveryMode(vars.entireSystemColl, vars.entireSystemDebt, _price);
                } else if vars.backToNormalMode && vars.ICR < MCR {
                    singleLiquidation = _liquidateNormalMode(
                        _contractsCache.activePool, _contractsCache.defaultPool, vars.user, vars.remainingLUSDInStabPool
                    );

                    vars.remainingLUSDInStabPool = vars.remainingLUSDInStabPool.sub(singleLiquidation.debtToOffset);

                    // Add liquidation values to their respective running totals
                    totals = _addLiquidationValuesToTotals(totals, singleLiquidation);
                } else {
                    break;
                } // break if the loop reaches a Trove with ICR >= MCR

                vars.user = nextUser;

                vars.i = vars.i + 1;
       }

}