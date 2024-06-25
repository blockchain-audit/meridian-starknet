#[starknet::interface]

trait IBorrowerOperations {
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
        LUSDBorrowingFeePaid: LUSDBorrowingFeePaid,
    }
    #[derive(Drop, starknet::Event)]
    struct TroveManagerAddressChanged {
        newTroveManagerAddress: felt252
    }
    #[derive(Drop, starknet::Event)]
    struct ActivePoolAddressChanged{
        activePoolAddress: felt252
    }
    #[derive(Drop, starknet::Event)]
    struct DefaultPoolAddressChanged{
        defaultPoolAddress: felt252
    }
    #[derive(Drop, starknet::Event)]
    struct StabilityPoolAddressChanged{
        stabilityPoolAddress: felt252
    }
    #[derive(Drop, starknet::Event)]
    struct GasPoolAddressChanged {
        gasPoolAddress: felt252
    }
    #[derive(Drop, starknet::Event)]
    struct CollSurplusPoolAddressChanged{
        collSurplusPoolAddress: felt252
    }
    #[derive(Drop, starknet::Event)]
    struct PriceFeedAddressChanged{
        newPriceFeedAddress: felt252
    }
    #[derive(Drop, starknet::Event)]
    struct SortedTrovesAddressChanged{
        sortedTrovesAddress: felt252
    }
    #[derive(Drop, starknet::Event)]
    struct LUSDTokenAddressChanged {
        lusdTokenAddress: felt252
    }
    #[derive(Drop, starknet::Event)]
    struct LQTYStakingAddressChanged {
        lqtyStakingAddress: felt252
    }
    #[derive(Drop, starknet::Event)]
    struct TroveCreated {
        borrower: felt252,
        arrayIndex: u256
    }
    #[derive(Drop, starknet::Event)]
    struct TroveUpdated {
        borrower: felt252,
        debt: u256,
        coll: u256,
        stake: u256,
        operation: u8
    }
    #[derive(Drop, starknet::Event)]
    struct LUSDBorrowingFeePaid {
        borrower: felt252,
        LUSDFee: u256
    }


    // --- Functions ---

    fn setAddresses(
        troveManagerAddress: felt252,
        activePoolAddress: felt252,
        defaultPoolAddress: felt252,
        stabilityPoolAddress: felt252,
        gasPoolAddress: felt252,
        collSurplusPoolAddress: felt252,
        priceFeedAddress: felt252,
        sortedTrovesAddress: felt252,
        lusdTokenAddress: felt252,
        lqtyStakingAddress: felt252
    ) ;

    fn openTrove(maxFee: u256, LUSDAmount: u256, upperHint: felt252, lowerHint: felt252);

    fn addColl(upperHint: felt252, lowerHint: felt252);

    fn moveETHGainToTrove(user: felt252, upperHint: felt252, lowerHint: felt252);

    fn withdrawColl(amount: u256, upperHint: felt252, lowerHint: felt252);

    fn withdrawLUSD(maxFee: u256, amount: u256, upperHint: felt252, lowerHint: felt252) ;

    fn repayLUSD(amount: u256, upperHint: u256, lowerHint: felt252);

    fn closeTrove();

    fn adjustTrove(
        maxFee: u256,
        collWithdrawal: u256,
        debtChange: u256,
        isDebtIncrease: bool,
        upperHint: felt252,
        lowerHint: felt252
    );

    fn claimCollateral();

    fn getCompositeDebt(debt; u256) -> u256;
}