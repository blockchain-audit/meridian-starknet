
<<<<<<< HEAD
=======
use starknet::ContractAddress;

#[starknet::interface]
trait ITroveManager<TContractState> {
    // --- Functions ---

    #[external(v0)]
    fn setAddresses(
        self: @TContractState,
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
    );

    // need to fix 4 function to return interface
    // ----------
    #[external(v0)]
    fn stabilityPool(self: @TContractState) -> ContractAddress;

    #[external(v0)]
    fn lusdToken(self: @TContractState) -> ContractAddress;

    #[external(v0)]
    fn lqtyToken(self: @TContractState) -> ContractAddress;

    #[external(v0)]
    fn lqtyStaking(self: @TContractState) -> ContractAddress;
    // -----------

    #[external(v0)]
    fn getTroveOwnersCount(self: @TContractState) -> u256;

    #[external(v0)]
    fn getTroveFromTroveOwnersArray(self: @TContractState, _index: u256) -> ContractAddress;

    #[external(v0)]
    fn getNominalICR(self: @TContractState, _borrower: ContractAddress) -> ContractAddress;

    #[external(v0)]
    fn getCurrentICR(self: @TContractState, _borrower: ContractAddress, _price: u256) -> u256;

    #[external(v0)]
    fn liquidate(self: @TContractState, _borrower: ContractAddress);

    #[external(v0)]
    fn liquidateTroves(self: @TContractState, _n: u256);

    #[external(v0)]
    fn batchLiquidateTroves(self: @TContractState, _troveArray: Array<ContractAddress>);

    #[external(v0)]
    fn redeemCollateral(
        self: @TContractState,
        _LUSDAmount: u256,
        _firstRedemptionHint: ContractAddress,
        _upperPartialRedemptionHint: ContractAddress,
        _lowerPartialRedemptionHint: ContractAddress,
        _partialRedemptionHintNICR: u256,
        _maxIterations: u256,
        _maxFee: u256
    );

    #[external(v0)]
    fn updateStakeAndTotalStakes(self: @TContractState, _borrower: ContractAddress) -> u256;

    #[external(v0)]
    fn updateTroveRewardSnapshots(self: @TContractState, _borrower: ContractAddress);

    #[external(v0)]
    fn addTroveOwnerToArray(self: @TContractState, _borrower: ContractAddress) -> u256;

    #[external(v0)]
    fn applyPendingRewards(self: @TContractState, _borrower: ContractAddress);

    #[external(v0)]
    fn getPendingETHReward(self: @TContractState, _borrower: ContractAddress) -> u256;

    #[external(v0)]
    fn getPendingLUSDDebtReward(self: @TContractState, _borrower: ContractAddress) -> u256;

    #[external(v0)]
    fn hasPendingRewards(self: @TContractState, _borrower: ContractAddress) -> u256;

    #[external(v0)]
    fn getEntireDebtAndColl(
        self: @TContractState, _borrower: ContractAddress
    ) -> (u256, u256, u256, u256);

    #[external(v0)]
    fn closeTrove(self: @TContractState, _borrower: ContractAddress);

    #[external(v0)]
    fn removeStake(self: @TContractState, _borrower: ContractAddress);

    #[external(v0)]
    fn getRedemptionRate(self: @TContractState) -> u256;

    #[external(v0)]
    fn getRedemptionRateWithDecay(self: @TContractState) -> u256;

    #[external(v0)]
    fn getRedemptionFeeWithDecay(self: @TContractState, _ETHDrawn: u256) -> u256;

    #[external(v0)]
    fn getBorrowingRate(self: @TContractState) -> u256;

    #[external(v0)]
    fn getBorrowingRateWithDecay(self: @TContractState) -> u256;

    #[external(v0)]
    fn getBorrowingFee(self: @TContractState, LUSDDebt: u256) -> u256;

    #[external(v0)]
    fn getBorrowingFeeWithDecay(self: @TContractState, _LUSDDebt: u256) -> u256;

    #[external(v0)]
    fn decayBaseRateFromBorrowing(self: @TContractState);

    #[external(v0)]
    fn getTroveStatus(self: @TContractState, _borrower: ContractAddress) -> u256;

    #[external(v0)]
    fn getTroveStake(self: @TContractState, _borrower: ContractAddress) -> u256;

    #[external(v0)]
    fn getTroveDebt(self: @TContractState, _borrower: ContractAddress) -> u256;

    #[external(v0)]
    fn getTroveColl(self: @TContractState, _borrower: ContractAddress) -> u256;

    #[external(v0)]
    fn setTroveStatus(self: @TContractState, _borrower: ContractAddress, num: u256);

    #[external(v0)]
    fn increaseTroveColl(
        self: @TContractState, _borrower: ContractAddress, _collIncrease: u256
    ) -> u256;

    #[external(v0)]
    fn decreaseTroveColl(
        self: @TContractState, _borrower: ContractAddress, _collDecrease: u256
    ) -> u256;

    #[external(v0)]
    fn increaseTroveDebt(
        self: @TContractState, _borrower: ContractAddress, _debtIncrease: u256
    ) -> u256;

    #[external(v0)]
    fn decreaseTroveDebt(
        self: @TContractState, _borrower: ContractAddress, _debtDecrease: u256
    ) -> u256;

    #[external(v0)]
    fn getTCR(self: @TContractState, _price: u256) -> u256;

    #[external(v0)]
    fn checkRecoveryMode(self: @TContractState, _price: u256) -> u256;

    fn main(self: @TContractState);
}

>>>>>>> bc72ff5a61cc30216d356898cdcda21881247bab
