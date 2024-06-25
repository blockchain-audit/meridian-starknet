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

    function setAddresses(
        address _troveManagerAddress,
        address _activePoolAddress,
        address _defaultPoolAddress,
        address _stabilityPoolAddress,
        address _gasPoolAddress,
        address _collSurplusPoolAddress,
        address _priceFeedAddress,
        address _sortedTrovesAddress,
        address _lusdTokenAddress,
        address _lqtyStakingAddress
    ) external;

    function openTrove(uint256 _maxFee, uint256 _LUSDAmount, address _upperHint, address _lowerHint) external payable;

    function addColl(address _upperHint, address _lowerHint) external payable;

    function moveETHGainToTrove(address _user, address _upperHint, address _lowerHint) external payable;

    function withdrawColl(uint256 _amount, address _upperHint, address _lowerHint) external;

    function withdrawLUSD(uint256 _maxFee, uint256 _amount, address _upperHint, address _lowerHint) external;

    function repayLUSD(uint256 _amount, address _upperHint, address _lowerHint) external;

    function closeTrove() external;

    function adjustTrove(
        uint256 _maxFee,
        uint256 _collWithdrawal,
        uint256 _debtChange,
        bool isDebtIncrease,
        address _upperHint,
        address _lowerHint
    ) external payable;

    function claimCollateral() external;

    function getCompositeDebt(uint256 _debt) external pure returns (uint256);
}