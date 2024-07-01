// %lang starknet

#[starknet::contract]
mod TroveManager {
    use debug::PrintTrait;
    use starknet::ContractAddress;
    use super::{IActivePool, IDefaultPool, IPriceFeed};
    use super::{stabilityPool};
    use utils::safeMath;
    use array::ArrayTrait;
    use starknet::syscalls::storage_read;
    use starknet::syscalls::storage_write;
    // import StructTroveManager as structs_trove
    //we need to connect this smart contract to safeMath contract 

    enum Event {
        BorrowerOperationsAddressChanged: BorrowerOperationsAddressChanged,
        PriceFeedAddressChanged: PriceFeedAddressChanged,
        LUSDTokenAddressChanged: LUSDTokenAddressChanged,
        ActivePoolAddressChanged: ActivePoolAddressChanged,
        DefaultPoolAddressChanged: DefaultPoolAddressChanged,
        StabilityPoolAddressChanged: StabilityPoolAddressChanged,
        GasPoolAddressChanged: GasPoolAddressChanged,
        CollSurplusPoolAddressChanged: CollSurplusPoolAddressChanged,
        SortedTrovesAddressChanged: SortedTrovesAddressChanged,
        LQTYTokenAddressChanged: LQTYTokenAddressChanged,
        LQTYStakingAddressChanged: LQTYStakingAddressChanged,
        Liquidation: Liquidation,
        Redemption: Redemption,
        TroveUpdated: TroveUpdated,
        LastFeeOpTimeUpdated: LastFeeOpTimeUpdated,
        BaseRateUpdated: BaseRateUpdated,
        TroveLiquidated: TroveLiquidated,
        SystemSnapshotsUpdated: SystemSnapshotsUpdated,
        TotalStakesUpdated: TotalStakesUpdated,
        TroveSnapshotsUpdated: TroveSnapshotsUpdated,
        LTermsUpdated: LTermsUpdated,
        TroveIndexUpdated: TroveIndexUpdated,
    }
    #[derive(Drop, starknet::Event)]
    struct BorrowerOperationsAddressChanged {
     _newBorrowerOperationsAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct PriceFeedAddressChanged {
     _newPriceFeedAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct LUSDTokenAddressChanged {
     _newLUSDTokenAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct ActivePoolAddressChanged {
     _activePoolAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct DefaultPoolAddressChanged {
     _defaultPoolAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct StabilityPoolAddressChanged {
     _stabilityPoolAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct GasPoolAddressChanged {
     _gasPoolAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct CollSurplusPoolAddressChanged {
     _collSurplusPoolAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct SortedTrovesAddressChanged {
     _sortedTrovesAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct LQTYTokenAddressChanged {
     _lqtyTokenAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct LQTYStakingAddressChanged {
     _lqtyStakingAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct Liquidation {
     _liquidatedDebt: felt252,
     _liquidatedColl: felt252,
     _collGasCompensation: felt252,
     _LUSDGasCompensation: felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct Redemption {
     _attemptedLUSDAmount: felt252,
     _actualLUSDAmount: felt252,
     _ETHSent: felt252,
     _ETHFee: felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct TroveUpdated {
     #[key]
     _borrower: ContractAddress,
     _debt: felt252,
     _coll: felt252,
     _stake: felt252,
     //check
     _operation: TroveManagerOperation,
    }
    #[derive(Drop, starknet::Event)]
    struct TroveLiquidated {
     #[key]
     _borrower: ContractAddress,
     _debt: felt252,
     _coll: felt252,
     //check
     _operation: TroveManagerOperation,
    }
    #[derive(Drop, starknet::Event)]
    struct BaseRateUpdated {
     _baseRate: felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct LastFeeOpTimeUpdated {
     _lastFeeOpTime: felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct TotalStakesUpdated {
     _newTotalStakes: felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct SystemSnapshotsUpdated {
     _totalStakesSnapshot: felt252,
     _totalCollateralSnapshot: felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct LTermsUpdated {
     _L_ETH: felt252,
     _L_LUSDDebt: felt252,
    }
    #[derive(Drop, starknet::Event)]
    //אותם משתנים רק שם האירוע שונה 
    struct TroveSnapshotsUpdated {
     _L_ETH: felt252,
     _L_LUSDDebt: felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct TroveIndexUpdated {
     _borrower: ContractAddress,
     _newIndex: felt252,
    }
    ///Structs
    #[storage]
    struct Trove {
     debt: felt252,
     coll: felt252,
     arrayIndex: felt252,
     stake: felt252,
    //צריך לבדוק ססטוס 
    // Status status;
    }
    //   Object containing the ETH and LUSD snapshots for a given active trove
    #[storage]
    struct RewardSnapshot {
        STARK: felt252,
        LUSDDebt: felt252,
    }
    #[storage]
    struct LocalVariables_OuterLiquidationFunction {
        price: felt252,
        LUSDInStabPool: felt252,
        recoveryModeAtStart: bool,
        liquidatedDebt: felt252,
        liquidatedColl: felt252,
    }
    #[storage]
    struct LocalVariables_InnerSingleLiquidateFunction {
     collToLiquidate: felt252,
     pendingDebtReward: felt252,
     pendingCollReward: felt252,
    }
    #[storage]
    struct LocalVariables_LiquidationSequence {
     remainingLUSDInStabPool: felt252,
     i: felt252,
     ICR: felt252,
     userAddress: ContractAddress,
     backToNormalMode: bool,
     entireSystemDebt: felt252,
     entireSystemColl: felt252,
    }
    #[storage]
   struct LiquidationValues {
     entireTroveDebt: felt252,
     entireTroveColl: felt252,
     collGasCompensation: felt252,
     LUSDGasCompensation: felt252,
     debtToOffset: felt252,
     collToSendToSP: felt252,
     debtToRedistribute: felt252,
     collToRedistribute: felt252,
     collSurplus: felt252,
    }
    #[storage]
    struct LiquidationTotals {
     totalCollInSequence: felt252,
     totalDebtInSequence: felt252,
     totalCollGasCompensation: felt252,
     totalLUSDGasCompensation: felt252,
     totalDebtToOffset: felt252,
     totalCollToSendToSP: felt252,
     totalDebtToRedistribute: felt252,
     totalCollToRedistribute: felt252,
     totalCollSurplus: felt252,
    }
    #[storage]
   struct ContractsCache {
     activePool: IActivePool,
     defaultPool: IDefaultPool,
     lusdToken: ILUSDToken,
     lqtyStaking: ILQTYStaking,
     sortedTroves: ISortedTroves,
     collSurplusPool: ICollSurplusPool,
     gasPoolAddress: ContractAddress,
    }
    #[storage]
    struct RedemptionTotals {
        remainingLUSD: felt252,
        totalLUSDToRedeem: felt252,
        totalSTARKDrawn: felt252,
        STARKFee: felt252,
        STARKToSendToRedeemer: felt252,
        decayedBaseRate: felt252,
        price: felt252,
        totalLUSDSupplyAtStart: felt252,
    }
    #[storage]
    struct SingleRedemptionValues {
        LUSDLot: felt252,
        STARKLot: felt252,
        cancelledPartial: bool,
    }
    #[storage]
    struct TroveManager {
     borrowerOperationsAddress: ContractAddress,
     stabilityPool:IStabilityPool,
     priceFeed: IPriceFeed,
     lqtyToken: ILQTYToken 
    }

    #[abi(embed_v0)]
      impl TroveManager of super::ITroveManager<ContractState> 
      {
 
       
       
    
    fn setAddresses(
            _borrowerOperationsAddress: ContractAddress,
            _activePoolAddress: ContractAddress,
            _defaultPoolAddress: ContractAddress,
            _stabilityPoolAddress: ContractAddress,
            _gasPoolAddress: ContractAddress,
            _collSurplusPoolAddress: ContractAddress,
            _priceFeedAddress: ContractAddress,
            _lusdTokenAddress: ContractAddress,
            _sortedTrovesAddress: ContractAddress,
            _lqtyTokenAddress: ContractAddress,
            _lqtyStakingAddress: ContractAddress
           ) 
           {
            assert_only_owner();
              
               self.borrowerOperationsAddress.write(_borrowerOperationsAddress);
               self.lqtyToken.write(ILQTYToken(_lqtyTokenAddress));
               self.stabilityPool.write(IStabilityPool(_stabilityPoolAddress));
               self.priceFeed.write(IPriceFeed(_priceFeedAddress));
   
               self.activePool.write(IActivePool(_activePoolAddress));
               self.defaultPool.write(IDefaultPool(_defaultPoolAddress));
               self.lusdToken.write(ILUSDToken(_lusdTokenAddress));
               self.lqtyStaking.write(ILQTYStaking(_lqtyStakingAddress));
               self.sortedTroves.write(ISortedTroves(_sortedTrovesAddress));
               self.collSurplusPool.write(ICollSurplusPool(_collSurplusPoolAddress));
               self.gasPoolAddress.write(_gasPoolAddress); 
           };
   
           self.emit(BorrowerOperationsAddressChanged {_newBorrowerOperationsAddress:_borrowerOperationsAddress});
           self.emit (ActivePoolAddressChanged {_activePoolAddress:_activePoolAddress});
           self.emit (DefaultPoolAddressChanged {_defaultPoolAddress:_defaultPoolAddress});
           self.emit (StabilityPoolAddressChanged {_stabilityPoolAddress:_stabilityPoolAddress});
           self.emit (GasPoolAddressChanged {_gasPoolAddress:_gasPoolAddress});
           self.emit (CollSurplusPoolAddressChanged {_collSurplusPoolAddress:_collSurplusPoolAddress});
           self.emit (PriceFeedAddressChanged {_newPriceFeedAddress:_priceFeedAddress});
           self.emit (LUSDTokenAddressChanged {_newLUSDTokenAddress:_lusdTokenAddress});
           self.emit (SortedTrovesAddressChanged {_sortedTrovesAddress:_sortedTrovesAddress});
           self.emit (LQTYTokenAddressChanged{_lqtyTokenAddress: _lqtyTokenAddress});
           self.emit (LQTYStakingAddressChanged {_lqtyStakingAddress:_lqtyStakingAddress});
   
           renounce_ownership();
   

    fn _addLiquidationValuesToTotals(
        oldTotals: LiquidationTotals, singleLiquidation: LiquidationValues
    ) -> LiquidationTotals {
        newTotals.totalCollGasCompensation = oldTotals.totalCollGasCompensation
            + singleLiquidation.collGasCompensation;
        newTotals.totalLUSDGasCompensation = oldTotals.totalLUSDGasCompensation
            + singleLiquidation.LUSDGasCompensation;
        newTotals.totalDebtInSequence = oldTotals.totalDebtInSequence
            + singleLiquidation.entireTroveDebt;
        newTotals.totalCollInSequence = oldTotals.totalCollInSequence
            + singleLiquidation.entireTroveColl;
        newTotals.totalDebtToOffset = oldTotals.totalDebtToOffset + singleLiquidation.debtToOffset;
        newTotals.totalCollToSendToSP = oldTotals.totalCollToSendToSP
            + singleLiquidation.collToSendToSP;
        newTotals.totalDebtToRedistribute = oldTotals.totalDebtToRedistribute
            + singleLiquidation.debtToRedistribute;
        newTotals.totalCollToRedistribute = oldTotals.totalCollToRedistribute
            + singleLiquidation.collToRedistribute;
        newTotals.totalCollSurplus = oldTotals.totalCollSurplus + singleLiquidation.collSurplus;

        newTotals;
    }


    #[view]
    fn hasPendingRewards(_borrower: felt252) -> bool {
        // /*
        // * A Trove has pending rewards if its snapshot is less than the current rewards per-unit-staked sum:
        // * this indicates that rewards have occured since the snapshot was made, and the user therefore has
        // * pending rewards
        // */

        return rewardSnapshots[_borrower].ETH < L_ETH && Troves[_borrower].status == Status.active;
    }


    fn _removeStake(_borrower: felt252) {
        let stake = storage_read(_borrower);
        totalStakes = totalStakes - stake;
        storage_write(borrower, 0);
    }

    fn batchLiquidateTroves(mut troveArray: ContractAddress) {
        assert(troveArray.length == 0, 'error, Calldata address array must not be empty');
        let mut activePoolCached: IActivePool = structs_trove.ContractsCache.activePool;
        let mut defaultPoolCached: IDefaultPool = structs_trove.ContractsCache.defaultPool;
        let mut priceFeed = IPriceFeed;
        //הממשק  לא מובן למה צריך לדרוס מתנה מטיפוס  
        //מבצע את כל 
        let mut stabilityPoolCached = stabilityPool;
        let mut vars = structs_trove.LocalVariables_OuterLiquidationFunction;
        let mut totals = structs_trove.LiquidationTotals;
        vars.price = priceFeed.fetchPrice();
        //מחזיר את total LUSD
        vars.LUSDInStabPool = stabilityPoolCached.getTotalLUSDDeposits();
        //who is function _checkRecoveryMode 
        vars.recoveryModeAtStart = _checkRecoveryMode(vars.price);
        if vars.recoveryModeAtStart {
            totals =
                getTotalFromBatchLiquidate_RecoveryMode(
                    activePoolCached, defaultPoolCached, vars.price, vars.LUSDInStabPool, troveArray
                );
        } else {
            totals =
                getTotalsFromBatchLiquidate_NormalMode(
                    activePoolCached, defaultPoolCached, vars.price, vars.LUSDInStabPool, troveArray
                );
        }
        assert(totals.totalDebtInSequence > 0, "TroveManager: nothing to liquidate");
        stabilityPoolCached.offset(totals.totalDebtToOffset, totals.totalCollToSendToSP);
        redistributeDebtAndColl(
            activePoolCached,
            defaultPoolCached,
            totals.totalDebtToRedistribute,
            totals.totalCollToRedistribute
        );
        if (totals.totalCollSurplus > 0) {
            activePoolCached.sendSTARK(ContractAddress(collSurplusPool), totals.totalCollSurplus);
        }
        // Update system snapshots
        updateSystemSnapshots_excludeCollRemainder(
            activePoolCached, totals.totalCollGasCompensation
        );
        vars.liquidatedDebt = totals.totalDebtInSequence;
        vars
            .liquidatedColl = totals
            .totalCollInSequence
            .sub(totals.totalCollGasCompensation)
            .sub(totals.totalCollSurplus);
        emit
        Liquidation(
            vars.liquidatedDebt,
            vars.liquidatedColl,
            totals.totalCollGasCompensation,
            totals.totalLUSDGasCompensation
        );
        self
            .emit(
                Liquidation {
                    _liquidatedDebt: vars.liquidatedDebt,
                    _liquidatedColl: vars.liquidatedColl,
                    _LUSDGasCompensation: totals.totalLUSDGasCompensation
                }
            );
        // {_liquidatedDebt: felt252,
        // _liquidatedColl:felt252,
        // _collGasCompensation:felt252,
        // _LUSDGasCompensation:felt252,}
        // Send gas compensation to caller
        sendGasCompensation(
            activePoolCached,
            msg.sender,
            totals.totalLUSDGasCompensation,
            totals.totalCollGasCompensation
        );
    }
    fn getTotalFromBatchLiquidate_RecoveryMode(
        activePool: IActivePool,
        defaultPool: IDefaultPool,
        price: felt252,
        LUSDInStabPool: felt252,
        mut troveArray: ContractAddress
    ) -> LiquidationTotals {}

    fn getTotalsFromBatchLiquidate_NormalMode(
        activePool: IActivePool,
        defaultPool: IDefaultPool,
        price: felt252,
        LUSDInStabPool: felt252,
        mut troveArray: ContractAddress
    ) -> LiquidationTotals {}

    fn redistributeDebtAndColl(
        activePool: IActivePool, defaultPool: IDefaultPool, debt: felt252, coll: felt252
    ) {}

    fn sendGasCompensation() {}
    #[event]
    #[derive(Drop, starknet::Event)]
    enum TroveManagerOperation {
        applyPendingRewards: applyPendingRewards,
        liquidateInNormalMode: liquidateInNormalMode,
        liquidateInRecoveryMode: liquidateInRecoveryMode,
        redeemCollateral: redeemCollateral,
    }
    fn _getTotalsFromLiquidateTrovesSequence_RecoveryMode(
        _contractsCache: ContractsCache //memory
        ,
        mut _price: u256,
        mut _LUSDInStabPool: u256,
        mut _n: u256
    ) -> LiquidationTotals { //memory
        let mut vars = LocalVariables_LiquidationSequence; //memory
        let mut singleLiquidation = LiquidationValues; //memory
        vars.remainingLUSDInStabPool = _LUSDInStabPool;
        vars.backToNormalMode = false;
        vars.entireSystemDebt = getEntireSystemDebt();
        vars.entireSystemColl = getEntireSystemColl();
        vars.user = _contractsCache.sortedTroves.getLast();
        let mut firstUser: ContractAddress = _contractsCache.sortedTroves.getFirst();
        vars.i = 0;
        loop {
            if vars.i > _n || vars.user == firstUser {
                break ();
            }
            let mut nextUser: ContractAddress = _contractsCache.sortedTroves.getPrev(vars.user);
            vars.ICR = getCurrentICR(vars.user, _price);
            if !vars.backToNormalMode {
                if vars.ICR >= MCR && vars.remainingLUSDInStabPool == 0 {
                    break ();
                }
                let mut TCR: u256 = LiquityMath
                    ._computeCR(vars.entireSystemColl, vars.entireSystemDebt, _price);
                singleLiquidation =
                    _liquidateRecoveryMode(
                        _contractsCache.activePool,
                        _contractsCache.defaultPool,
                        vars.user,
                        vars.ICR,
                        vars.remainingLUSDInStabPool,
                        TCR,
                        _price
                    );
                vars
                    .remainingLUSDInStabPool = vars
                    .remainingLUSDInStabPool
                    .sub(singleLiquidation.debtToOffset);
                vars.entireSystemDebt = vars.entireSystemDebt.sub(singleLiquidation.debtToOffset);
                vars
                    .entireSystemColl = vars
                    .entireSystemColl
                    .sub(singleLiquidation.collToSendToSP)
                    .sub(singleLiquidation.collGasCompensation)
                    .sub(singleLiquidation.collSurplus);
                totals = _addLiquidationValuesToTotals(totals, singleLiquidation);
                vars
                    .backToNormalMode =
                        !_checkPotentialRecoveryMode(
                            vars.entireSystemColl, vars.entireSystemDebt, _price
                        );
            } else if vars.backToNormalMode && vars.ICR < MCR {
                singleLiquidation =
                    _liquidateNormalMode(
                        _contractsCache.activePool,
                        _contractsCache.defaultPool,
                        vars.user,
                        vars.remainingLUSDInStabPool
                    );

                vars
                    .remainingLUSDInStabPool = vars
                    .remainingLUSDInStabPool
                    .sub(singleLiquidation.debtToOffset);
                totals = _addLiquidationValuesToTotals(totals, singleLiquidation);
            } else {
                break ();
            }
            vars.user = nextUser;
            vars.i = vars.i + 1;
        }
    }
    fn _sendGasCompensation(
        _activePool: IActivePool, _liquidator: address, _LUSD: uint256, _ETH: uint256
    ) {
        if _LUSD > 0 {
            lusdToken.returnFromPool(gasPoolAddress, _liquidator, _LUSD);
        }

        if _ETH > 0 {
            _activePool.sendETH(_liquidator, _ETH);
        }
    }
    fn _movePendingTroveRewardsToActivePool(
        _activePool: IActivePool, _defaultPool: IDefaultPool, _LUSD: uint256, _ETH: uint256
    ) {
        _defaultPool.decreaseLUSDDebt(_LUSD);
        _activePool.increaseLUSDDebt(_LUSD);
        _defaultPool.sendETHToActivePool(_ETH);
    }


    fn _redeemCloseTrove(
        _contractsCache: ContractsCache, //memory
        _borrower: ContractAddress,
        _LUSD: u256,
        _ETH: u256
    ) {
        _contractsCache.lusdToken.burn(gasPoolAddress, _LUSD);
        _contractsCache.activePool.decreaseLUSDDebt(_LUSD);
        _contractsCache.collSurplusPool.accountSurplus(_borrower, _ETH);
        _contractsCache.activePool.sendETH(ContractAddress(_contractsCache.collSurplusPool), _ETH);
    }

    fn _isValidFirstRedemptionHint(
        _sortedTroves: ISortedTroves, _firstRedemptionHint: ContractAddress, _price: u256
    ) -> bool {
        if _firstRedemptionHint == address(0)
            || !_sortedTroves.contains(_firstRedemptionHint)
            || getCurrentICR(_firstRedemptionHint, _price) < MCR {
            false
        }
        let nextTrove: ContractAddress = _sortedTroves.getNext(_firstRedemptionHint);
        if nextTrove == address(0) || getCurrentICR(nextTrove, _price) < MCR {
            true
        } else {
            false
        }
    }

    #[external(v0)]
    fn getTroveOwnersCount(self: @ContractState) -> u256 {
        return TroveOwners.length;
    }

    #[external(v0)]
    fn getTroveFromTroveOwnersArray(self: @ContractState, index: u256) -> ContractAddress {
        return TroveOwners[index];
    }
}
}







