use starknet::ContractAddress;
#[starknet::interface]

trait IBorrowerOperations<TContractState> {



    // --- Functions ---

    fn setAddresses(
        troveManagerAddress: ContractAddress,
        activePoolAddress: ContractAddress,
        defaultPoolAddress: ContractAddress,
        stabilityPoolAddress: ContractAddress,
        gasPoolAddress: ContractAddress,
        collSurplusPoolAddress: ContractAddress,
        priceFeedAddress: ContractAddress,
        sortedTrovesAddress: ContractAddress,
        lusdTokenAddress: ContractAddress,
        lqtyStakingAddress: ContractAddress
    ) ;

    fn openTrove(ref self: TContractState, maxFee: u256, LUSDAmount: u256, upperHint: ContractAddress, lowerHint: ContractAddress);

    fn addColl(ref self: TContractState, upperHint: ContractAddress, lowerHint: ContractAddress);

    fn moveETHGainToTrove(ref self: TContractState, user: ContractAddress, upperHint: ContractAddress, lowerHint: ContractAddress);

    fn withdrawColl(ref self: TContractState, amount: u256, upperHint: ContractAddress, lowerHint: ContractAddress);

    fn withdrawLUSD(ref self: TContractState, maxFee: u256, amount: u256, upperHint: ContractAddress, lowerHint: ContractAddress) ;

    fn repayLUSD(ref self: TContractState, amount: u256, upperHint: u256, lowerHint: ContractAddress);

    fn closeTrove(ref self: TContractState);

    fn adjustTrove(
        ref self: TContractState,
        maxFee: u256,
        collWithdrawal: u256,
        debtChange: u256,
        isDebtIncrease: bool,
        upperHint: ContractAddress,
        lowerHint: ContractAddress
    );

    fn claimCollateral(ref self: TContractState);

    fn getCompositeDebt(ref self: TContractState, debt: u256) -> u256;
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
    LUSDBorrowingFeePaid: LUSDBorrowingFeePaid,
}
#[derive(Drop, starknet::Event)]
struct TroveManagerAddressChanged {
    newTroveManagerAddress: ContractAddress
}
#[derive(Drop, starknet::Event)]
struct ActivePoolAddressChanged{
    activePoolAddress: ContractAddress
}
#[derive(Drop, starknet::Event)]
struct DefaultPoolAddressChanged{
    defaultPoolAddress: ContractAddress
}
#[derive(Drop, starknet::Event)]
struct StabilityPoolAddressChanged{
    stabilityPoolAddress: ContractAddress
}
#[derive(Drop, starknet::Event)]
struct GasPoolAddressChanged {
    gasPoolAddress: ContractAddress
}
#[derive(Drop, starknet::Event)]
struct CollSurplusPoolAddressChanged{
    collSurplusPoolAddress: ContractAddress
}
#[derive(Drop, starknet::Event)]
struct PriceFeedAddressChanged{
    newPriceFeedAddress: ContractAddress
}
#[derive(Drop, starknet::Event)]
struct SortedTrovesAddressChanged{
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
    operation: u8
}
#[derive(Drop, starknet::Event)]
struct LUSDBorrowingFeePaid {
    #[key]
    borrower: ContractAddress,
    LUSDFee: u256
}