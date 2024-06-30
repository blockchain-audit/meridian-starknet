
use starknet::ContractAddress;
use trove::interfaces::IBorrowerOperations;\

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
    fn addColl() {}
    fn moveETHGainToTrove() {}
    #[external(v0)]
    fn withdrawColl(collWithdrawal:u256, upperHint:ContractAddress, lowerHint:ContractAddress) {
        _adjustTrove(msg.sender, collWithdrawal, 0, false, upperHint, lowerHint, 0);
    }
    #[external(v0)]
    fn withdrawLUSD(maxFeePercentage:u256, LUSDAmount:u256, upperHint:ContractAddress, lowerHint:ContractAddress) {
        _adjustTrove(msg.sender, 0, LUSDAmount, true, upperHint, lowerHint, maxFeePercentage);
    }
    #[external(v0)]
    fn repayLUSD(LUSDAmount:u256, upperHint:ContractAddress, lowerHint:ContractAddress) {
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
    fn _updateTroveFromAdjustment() {}
    fn _moveTokensAndETHfromAdjustment() {}
    fn _activePoolAddColl() {}
    fn _requireNotInRecoveryMode() {}

    fn _requireValidLUSDRepayment(currentDebt: u256, debtRepayment: u256) {
        assert(
            debtRepayment <= currentDebt.sub(LUSD_GAS_COMPENSATION),
            'BorrowerOps: Amount repaid must not be larger than the Troves debt'
        );
    }
    fn _requireAtLeastMinNetDebt(newICR: u256, oldICR: u256) {
        assert(newICR >= oldICR, "BorrowerOps: Cannot decrease your Trove's ICR in Recovery Mode");
    }

    fn _requireAtLeastMinNetDebt(const netDebt: u256)  {
        assert(netDebt >= MIN_NET_DEBT, "BorrowerOps: Trove's net debt must be greater than minimum");
    }

    #[view]
    fn _requireNonZeroAdjustment(self: @ContractState, collWithdrawal: u256, LUSDChange: u256) {
        assert(
            msg.value != 0 || collWithdrawal != 0 || LUSDChange != 0,
            "BorrowerOps: There must be either a collateral change or a debt change"
        );
    }

    #[view]
    fn _requireTroveisActive(self: @ContractState, troveManager ITroveManager,  borrower ContractAddress )   {
        status: u256 = troveManager.getTroveStatus(borrower);
        assert(status == 1, "BorrowerOps: Trove does not exist or is closed");
    }

    #[view]
    function _requireTroveisNotActive(self: @ContractState,  troveManager ITroveManager,  borrower ContractAddress)   {
        status:u256 = troveManager.getTroveStatus(borrower);
        assert(status != 1, "BorrowerOps: Trove is active");
    }

    fn _requireNewTCRisAboveCCR() {}
    fn _getNewTCRFromTroveChange() {}
    fn _getNewTroveAmounts() {}
    fn _getNewICRFromTroveChange() {}
    fn _getNewNominalICRFromTroveChange() {}
    fn getCompositeDebt() {}
    
    fn _requireNewICRisAboveOldICR(newICR: u256, oldICR: u256) {
        assert(_newICR >= oldICR, "BorrowerOps: Cannot decrease your Trove's ICR in Recovery Mode");
    }
    #[view]
    fn _requireCallerIsBorrower(self: @ContractState, borrower: ContractAddress) {
        assert(msg.sender == borrower, "BorrowerOps: Caller must be the borrower for a withdrawal");
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

    #[view]
    fn _requireNonZeroAdjustment(self: @ContractState, collWithdrawal: u256, LUSDChange: u256) {
        assert(
            msg.value != 0 || collWithdrawal != 0 || LUSDChange != 0,
            "BorrowerOps: There must be either a collateral change or a debt change"
        );
    }
    fn _requireNoCollWithdrawal(const ollWithdrawal :u256)  {
        assert(_collWithdrawal == 0, "BorrowerOps: Collateral withdrawal not permitted Recovery Mode");
    }
    fn _requireNonZeroDebtChange(const  _LUSDChange :u256)    {
        assert(_LUSDChange > 0, "BorrowerOps: Debt increase requires non-zero debtChange");
    }

    fn _requireICRisAboveMCR(const newICR:felt256){
        assert(newICR >= MCR, "BorrowerOps: An operation that would result in ICR < MCR is not permitted");
    }

    fn _requireICRisAboveCCR(const newICR:felt256){
        assert(newICR >= CCR, "BorrowerOps: Operation must leave trove with ICR >= CCR");
    }

    #[view]
    fn _requireValidAdjustmentInCurrentMode(
                self: @ContractState, 
                isRecoveryMode:bool,
                collWithdrawal:felt256,
                isDebtIncrease:bool,
                vars:LocalVariables_adjustTrove 
        ){
            if (isRecoveryMode){
                _requireNoCollWithdrawal(collWithdrawal);
                if(isDebtIncrease){
                    _requireICRisAboveCCR(vars.newICR);
                    _requireNewICRisAboveOldICR(vars.newICR, vars.oldICR);
                }
            }else{
                _requireICRisAboveMCR(vars.newICR);
                vars.newTCR = _getNewTCRFromTroveChange(
                      vars.collChange, vars.isCollIncrease, vars.netDebtChange, isDebtIncrease, vars.price
                );
                _requireNewTCRisAboveCCR(vars.newTCR);
            }
    }

    fn _requireValidMaxFeePercentage(const maxFeePercentage :u256, const isRecoveryMode bool) {
        if isRecoveryMode {
            assert(maxFeePercentage <= DECIMAL_PRECISION, "Max fee percentage must less than or equal to 100%");
        } else {
            assert(
                _maxFeePercentage >= BORROWING_FEE_FLOOR && maxFeePercentage <= DECIMAL_PRECISION,
                "Max fee percentage must be between 0.5% and 100%"
            );
        }
    }
    #[view]
    fn _requireSufficientLUSDBalance( self: @ContractState, lusdToken ILUSDToken, borrower ContractAddress,  debtRepayment :u256) {
        assert(
            lusdToken.balanceOf(borrower) >= debtRepayment,
            "BorrowerOps: Caller doesnt have enough LUSD to make repayment"
        );
    }
    
    #[view]
    fn _requireCallerIsStabilityPool(self: @ContractState)   {
        assert(msg.sender == stabilityPoolAddress, "BorrowerOps: Caller is not Stability Pool");
    }

    #[external(v0)]
    fn moveETHGainToTrove(borrower ContractAddress, upperHint ContractAddress, lowerHint ContractAddress) {
        _requireCallerIsStabilityPool();
        _adjustTrove(borrower, 0, 0, false, upperHint, lowerHint, 0);
    }

    #[external(v0)]
    fn addColl(upperHint ContractAddress, lowerHint ContractAddress) {
        _adjustTrove(msg.sender, 0, 0, false, upperHint, lowerHint, 0);
    }


    fn main() {}

}



