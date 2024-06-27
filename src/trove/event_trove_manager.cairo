#[starknet::contract] 
use starknet::ContractAddress;
impl LUSDTokenAddressChangedDrop of Drop::<LUSDTokenAddressChanged
mod EventsTroveManager{

    enum TroveManagerOperation {
            applyPendingRewards:applyPendingRewards,
            liquidateInNormalMode:liquidateInNormalMode,
            liquidateInRecoveryMode:liquidateInRecoveryMode,
            redeemCollateral:redeemCollateral,
        }

    #[derive(Drop, starknet::Event)]
    struct BorrowerOperationsAddressChanged{
        _newBorrowerOperationsAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct PriceFeedAddressChanged{
        _newPriceFeedAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct LUSDTokenAddressChanged{
        _newLUSDTokenAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct ActivePoolAddressChanged{
        _activePoolAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct DefaultPoolAddressChanged{
        _defaultPoolAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct StabilityPoolAddressChanged{
        _stabilityPoolAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct GasPoolAddressChanged{
        _gasPoolAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct CollSurplusPoolAddressChanged{
        _collSurplusPoolAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct SortedTrovesAddressChanged{
        _sortedTrovesAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct LQTYTokenAddressChanged{
        _lqtyTokenAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct LQTYStakingAddressChanged{
        _lqtyStakingAddress: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct Liquidation{
        _liquidatedDebt: felt252,
        _liquidatedColl:felt252,
        _collGasCompensation:felt252,
        _LUSDGasCompensation:felt252,
    }   
    #[derive(Drop, starknet::Event)]
    struct Redemption{
        _attemptedLUSDAmount: felt252,
        _actualLUSDAmount:felt252,
        _STARKSent:felt252,
        _STARKFee:felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct TroveUpdated{
        indexed_borrower: ContractAddress,
        _debt:felt252,
        _coll:felt252,
        _stake:felt252,
        //check
        _operation:TroveManagerOperation,
    }
    #[derive(Drop, starknet::Event)]
    struct TroveLiquidated{
        indexed_borrower: ContractAddress,
        _debt:felt252,
        _coll:felt252,
        //check
        _operation:TroveManagerOperation,
    }
    #[derive(Drop, starknet::Event)]
    struct BaseRateUpdated{
        _baseRate:felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct LastFeeOpTimeUpdated{
        _lastFeeOpTime:felt252,
    } 
    #[derive(Drop, starknet::Event)]
    struct TotalStakesUpdated{
        _newTotalStakes:felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct SystemSnapshotsUpdated{
        _totalStakesSnapshot:felt252,
        _totalCollateralSnapshot:felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct LTermsUpdated{
        _L_STARK:felt252,
        _L_LUSDDebt:felt252,
    }
    #[derive(Drop, starknet::Event)]
    //אותם משתנים רק שם האירוע שונה 
    struct TroveSnapshotsUpdated{
        _L_STARK:felt252,
        _L_LUSDDebt:felt252,
    }
    #[derive(Drop, starknet::Event)]
    struct TroveIndexUpdated{
        _borrower:ContractAddress,
        _newIndex:felt252,
    }
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        BorrowerOperationsAddressChanged: BorrowerOperationsAddressChanged,
        PriceFeedAddressChanged:PriceFeedAddressChanged,
        LUSDTokenAddressChanged:LUSDTokenAddressChanged,
        ActivePoolAddressChanged:ActivePoolAddressChanged,
        DefaultPoolAddressChanged:DefaultPoolAddressChanged,
        StabilityPoolAddressChanged:StabilityPoolAddressChanged,
        GasPoolAddressChanged:GasPoolAddressChanged,
        CollSurplusPoolAddressChanged:CollSurplusPoolAddressChanged,
        SortedTrovesAddressChanged:SortedTrovesAddressChanged,
        LQTYTokenAddressChanged:LQTYTokenAddressChanged,
        LQTYStakingAddressChanged:LQTYStakingAddressChanged,
        Liquidation:Liquidation,
        Redemption:Redemption,
        TroveUpdated:TroveUpdated,
        LastFeeOpTimeUpdated:LastFeeOpTimeUpdated,
        BaseRateUpdated:BaseRateUpdated,
        TroveLiquidated:TroveLiquidated,
        SystemSnapshotsUpdated:SystemSnapshotsUpdated,
        TotalStakesUpdated:TotalStakesUpdated,
        TroveSnapshotsUpdated:TroveSnapshotsUpdated,
        LTermsUpdated:LTermsUpdated,
        TroveIndexUpdated:TroveIndexUpdated,
        
    }
}
  
