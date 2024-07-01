use starknet::ContractAddress;
use trove::interfaces::IBorrowerOperations;

#[starknet::contract]
mod BorrowerOperations {
    #[derive(Copy, Drop)]
    struct LocalVariables_adjustTrove {
        price: u256,
        collChange: u256,
        netDebtChange: u256,
        isCollIncrease: bool,
        debt: u256,
        coll: u256,
        oldICR: u256,
        newICR: u256,
        newTCR: u256,
        LUSDFee: u256,
        newDebt: u256,
        newColl: u256,
        stake: u256,
    }

    #[derive(Copy, Drop)]
    struct LocalVariables_openTrove {
        price: u256,
        LUSDFee: u256,
        netDebt: u256,
        compositeDebt: u256,
        ICR: u256,
        NICR: u256,
        stake: u256,
        arrayIndex: u256,
    }

    #[derive(Drop)]
    struct ContractsCache {
        troveManager: u256,
        activePool: u256,
        lusdToken: u256,
    }

    #[derive(Drop)]
    enum BorrowerOperation {
        openTrove,
        closeTrove,
        adjustTrove
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        TroveManagerAddressChanged: TroveManagerAddressChanged,
        ActivePoolAddressChanged: ActivePoolAddressChanged,
        DefaultPoolAddressChanged: DefaultPoolAddressChanged,
        StabilityPoolAddressChanged: StabilityPoolAddressChanged,
        GasPoolAddressChanged: GasPoolAddressChanged,
        CollSurplusPoolAddressChanged: CollSurplusPoolAddressChanged,
        PriceFeedAddressChanged: PriceFeedAddressChanged,
        SortedTrovesAddressChanged: SortedTrovesAddressChanged,
        LUSDTokenAddressChanged: LUSDTokenAddressChanged,
        LQTYStakingAddressChanged: LQTYStakingAddressChanged,
        TroveCreated: TroveCreated,
        TroveUpdated: TroveUpdated,
        LUSDBorrowingFeePaid: LUSDBorrowingFeePaid
    }

    #[derive(Drop, starknet::Event)]
    struct TroveManagerAddressChanged {
        newTroveManagerAddress: ContractAddress
    }
    #[derive(Drop, starknet::Event)]
    struct ActivePoolAddressChanged {
        activePoolAddress: ContractAddress
    }
    #[derive(Drop, starknet::Event)]
    struct DefaultPoolAddressChanged {
        defaultPoolAddress: ContractAddress
    }
    #[derive(Drop, starknet::Event)]
    struct StabilityPoolAddressChanged {
        stabilityPoolAddress: ContractAddress
    }
    #[derive(Drop, starknet::Event)]
    struct GasPoolAddressChanged {
        gasPoolAddress: ContractAddress
    }
    #[derive(Drop, starknet::Event)]
    struct CollSurplusPoolAddressChanged {
        collSurplusPoolAddress: ContractAddress
    }
    #[derive(Drop, starknet::Event)]
    struct PriceFeedAddressChanged {
        newPriceFeedAddress: ContractAddress
    }
    #[derive(Drop, starknet::Event)]
    struct SortedTrovesAddressChanged {
        sortedTrovesAddress: ContractAddress
    }
    #[derive(Drop, starknet::Event)]
    struct LUSDTokenAddressChanged {
        lusdTokenAddress: ContractAddress
    }
    #[derive(Drop, starknet::Event)]
    struct LQTYStakingAddressChanged {
        lqtyStakingAddress: ContractAddress
    }

    #[derive(Drop, starknet::Event)]
    struct TroveCreated {
        #[key]
        borrower: ContractAddress,
        arrayIndex: u256
    }

    #[derive(Drop, starknet::Event)]
    struct TroveUpdated {
        #[key]
        borrower: ContractAddress,
        debt: u256,
        coll: u256,
        stake: u256,
        operation: BorrowerOperation
    }
    #[derive(Drop, starknet::Event)]
    struct LUSDBorrowingFeePaid {
        #[key]
        borrower: ContractAddress,
        LUSDFee: u256
    }

    fn setAddresses() {}

    fn openTrove() {}
    #[external(v0)]
    fn addColl(upperHint: ContractAddress, lowerHint: ContractAddress) {
        _adjustTrove(msg.sender, 0, 0, false, upperHint, lowerHint, 0);
    }
    #[external(v0)]
    fn moveETHGainToTrove(
        borrower: ContractAddress, upperHint: ContractAddress, lowerHint: ContractAddress
    ) {
        _requireCallerIsStabilityPool();
        _adjustTrove(borrower, 0, 0, false, upperHint, lowerHint, 0);
    }
    #[external(v0)]
    fn withdrawColl(collWithdrawal: u256, upperHint: ContractAddress, lowerHint: ContractAddress) {
        _adjustTrove(msg.sender, collWithdrawal, 0, false, upperHint, lowerHint, 0);
    }
    #[external(v0)]
    fn withdrawLUSD(
        maxFeePercentage: u256,
        LUSDAmount: u256,
        upperHint: ContractAddress,
        lowerHint: ContractAddress
    ) {
        _adjustTrove(msg.sender, 0, LUSDAmount, true, upperHint, lowerHint, maxFeePercentage);
    }
    #[external(v0)]
    fn repayLUSD(LUSDAmount: u256, upperHint: ContractAddress, lowerHint: ContractAddress) {
        _adjustTrove(msg.sender, 0, LUSDAmount, false, upperHint, lowerHint, 0);
    }
    fn closeTrove() {}

    #[external]
    fn claimCollateral() {
        let caller = get_caller_address();
        collSurplusPool.claimColl(caller);
    }

    fn _triggerBorrowingFee() {}
    fn _getUSDValue() {}
    fn _getCollChange() {}
    fn _activePoolAddColl() {}
    fn _withdrawLUSD() {}
    fn _repayLUSD() {}
    fn _requireValidLUSDRepayment(currentDebt: u256, debtRepayment: u256) {
        assert(
            debtRepayment <= currentDebt.sub(LUSD_GAS_COMPENSATION),
            'BorrowerOps: Amount repaid must not be larger than the Troves debt'
        );
    }

    #[view]
    fn _requireNonZeroAdjustment(self: @ContractState, collWithdrawal: u256, LUSDChange: u256) {
        assert(
            msg.value != 0 || collWithdrawal != 0 || LUSDChange != 0,
            "BorrowerOps: There must be either a collateral change or a debt change"
        );
    }

    #[view]
    fn _requireTroveisActive(
        self: @ContractState, troveManager: ITroveManager, borrower: ContractAddress
    ) {
        let status: u256 = troveManager.getTroveStatus(borrower);
        assert(status == 1, "BorrowerOps: Trove does not exist or is closed");
    }

    #[view]
    fn _requireTroveisNotActive(
        self: @ContractState, troveManager: ITroveManager, borrower: ContractAddress
    ) {
        let status: u256 = troveManager.getTroveStatus(borrower);
        assert(status != 1, "BorrowerOps: Trove is active");
    }

    fn _requireNewTCRisAboveCCR() {}

    fn _getNewTCRFromTroveChange(
        collChange: u256, isCollIncrease: bool, debtChange: u256, isDebtIncrease: bool, price: u256
    ) -> u256 {
        let totalColl = getEntireSystemColl();
        let totalDebt = getEntireSystemColl();
        if totalColl == _isCollIncrease {
            totalColl.add(_collChange);
        } else {
            totalColl.sub(_collChange);
        }
        if totalColl == _isDebtIncrease {
            totalDebt.add(_debtChange)
        } else {
            totalDebt.sub(_debtChange);
        }
        let newTCR = LiquityMath.computeCR(totalColl, totalDebt, price);
        newTCR
    }


    fn _getNewTroveAmounts() {}
    fn _getNewICRFromTroveChange() {}
    fn _getNewNominalICRFromTroveChange() {}

    #[external(v0)]
    fn getCompositeDebt(debt: u256) -> u256 {
        _getCompositeDebt(debt)
    }

    fn _requireNewICRisAboveOldICR(newICR: u256, oldICR: u256) {
        assert(_newICR >= oldICR, "BorrowerOps: Cannot decrease your Trove's ICR in Recovery Mode");
    }

    fn _requireAtLeastMinNetDebt(netDebt: u256) {
        assert(
            netDebt >= MIN_NET_DEBT, "BorrowerOps: Trove's net debt must be greater than minimum"
        );
    }
    #[view]
    fn _requireSingularCollChange(self: @ContractState, collWithdrawal: u256) {
        assert(
            msg.value == 0 || collWithdrawal == 0,
            "BorrowerOperations: Cannot withdraw and add coll"
        );
    }
    #[view]
    fn _requireCallerIsBorrower(self: @ContractState, borrower: ContractAddress) {
        assert(msg.sender == borrower, "BorrowerOps: Caller must be the borrower for a withdrawal");
    }

    fn _requireNoCollWithdrawal(ollWithdrawal: u256) {
        assert(
            _collWithdrawal == 0, "BorrowerOps: Collateral withdrawal not permitted Recovery Mode"
        );
    }
    fn _requireNonZeroDebtChange(_LUSDChange: u256) {
        assert(_LUSDChange > 0, "BorrowerOps: Debt increase requires non-zero debtChange");
    }

    fn _requireICRisAboveMCR(newICR: felt256) {
        assert(
            newICR >= MCR,
            "BorrowerOps: An operation that would result in ICR < MCR is not permitted"
        );
    }

    fn _requireICRisAboveCCR(newICR: felt256) {
        assert(newICR >= CCR, "BorrowerOps: Operation must leave trove with ICR >= CCR");
    }

    #[view]
    fn _requireValidAdjustmentInCurrentMode(
        self: @ContractState,
        isRecoveryMode: bool,
        collWithdrawal: felt256,
        isDebtIncrease: bool,
        vars: LocalVariables_adjustTrove
    ) {
        if (isRecoveryMode) {
            _requireNoCollWithdrawal(collWithdrawal);
            if (isDebtIncrease) {
                _requireICRisAboveCCR(vars.newICR);
                _requireNewICRisAboveOldICR(vars.newICR, vars.oldICR);
            }
        } else {
            _requireICRisAboveMCR(vars.newICR);
            vars
                .newTCR =
                    _getNewTCRFromTroveChange(
                        vars.collChange,
                        vars.isCollIncrease,
                        vars.netDebtChange,
                        isDebtIncrease,
                        vars.price
                    );
            _requireNewTCRisAboveCCR(vars.newTCR);
        }
    }

    fn _requireValidMaxFeePercentage(maxFeePercentage: u256, isRecoveryMode: bool) {
        if isRecoveryMode {
            assert(
                maxFeePercentage <= DECIMAL_PRECISION,
                "Max fee percentage must less than or equal to 100%"
            );
        } else {
            assert(
                _maxFeePercentage >= BORROWING_FEE_FLOOR && maxFeePercentage <= DECIMAL_PRECISION,
                "Max fee percentage must be between 0.5% and 100%"
            );
        }
    }
    #[view]
    fn _requireSufficientLUSDBalance(
        self: @ContractState, lusdToken: ILUSDToken, borrower: ContractAddress, debtRepayment: u256
    ) {
        assert(
            lusdToken.balanceOf(borrower) >= debtRepayment,
            "BorrowerOps: Caller doesnt have enough LUSD to make repayment"
        );
    }

    #[view]
    fn _requireCallerIsStabilityPool(self: @ContractState) {
        assert(msg.sender == stabilityPoolAddress, "BorrowerOps: Caller is not Stability Pool");
    }

    fn main() {}


    fn _updateTroveFromAdjustment(
        _troveManager: ITroveManager,
        _borrower: ContractAddress,
        _collChange: u256,
        _isCollIncrease: bool,
        _debtChange: u256,
        _isDebtIncrease: bool
    ) -> (u256, u256) {
        let mut newColl: u256 = if _isCollIncrease {
            _troveManager.increaseTroveColl(_borrower, _collChange)
        } else {
            _troveManager.decreaseTroveColl(_borrower, _collChange)
        };
        let mut newDebt: u256 = if _isDebtIncrease {
            _troveManager.increaseTroveDebt(_borrower, _debtChange)
        } else {
            _troveManager.decreaseTroveDebt(_borrower, _debtChange)
        };
        (newColl, newDebt)
    }


    fn _moveTokensAndETHfromAdjustment(
        _activePool: IActivePool,
        _lusdToken: ILUSDToken,
        _borrower: ContractAddress,
        _collChange: u256,
        _isCollIncrease: bool,
        _LUSDChange: u256,
        _isDebtIncrease: bool,
        _netDebtChange: u256
    ) {
        if (_isDebtIncrease) {
            _withdrawLUSD(_activePool, _lusdToken, _borrower, _LUSDChange, _netDebtChange);
        } else {
            _repayLUSD(_activePool, _lusdToken, _borrower, _LUSDChange);
        }

        if (_isCollIncrease) {
            _activePoolAddColl(_activePool, _collChange);
        } else {
            _activePool.sendETH(_borrower, _collChange);
        }
    }

    #[view]
    fn _requireNotInRecoveryMode(self: @ContractState, price: u256) {
        assert(
            !_checkRecoveryMode(price), "BorrowerOps: Operation not permitted during Recovery Mode"
        );
    }

    fn main() {}
}

