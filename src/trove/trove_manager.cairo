#[starknet::contract]

mod TroveManager {
  use starknet::ContractAddress;
  use openzeppelin::access::ownable::library::Ownable;
  use super::interfaces::{ILQTYToken,IPriceFeed,IStabilityPool,ITroveManager};
  use array::ArrayTrait;
  use starknet::syscalls::storage_read;
  use starknet::syscalls::storage_write;

  #[event]
  #[derive(Drop, starknet::Event)]
   enum TroveManagerOperation {
     applyPendingRewards: applyPendingRewards,
     liquidateInNormalMode: liquidateInNormalMode,
     liquidateInRecoveryMode: liquidateInRecoveryMode,
     redeemCollateral: redeemCollateral,
    }
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
     ETH: felt252,
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
     totalETHDrawn: felt252,
     ETHFee: felt252,
     ETHToSendToRedeemer: felt252,
     decayedBaseRate: felt252,
     price: felt252,
     totalLUSDSupplyAtStart: felt252,
    }
    #[storage]
    struct SingleRedemptionValues {
     LUSDLot: felt252,
     ETHLot: felt252,
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
       
       
        #[view]
        fn hasPendingRewards(_borrower:felt252)  -> bool {
        // /*
        // * A Trove has pending rewards if its snapshot is less than the current rewards per-unit-staked sum:
        // * this indicates that rewards have occured since the snapshot was made, and the user therefore has
        // * pending rewards
        // */

        return rewardSnapshots[_borrower].ETH < L_ETH && Troves[_borrower].status == Status.active;
        }


       fn _removeStake( _borrower:felt252)  {


        let stake = storage_read(_borrower);
        totalStakes = totalStakes - stake;
        storage_write(borrower, 0);
    
      }
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

      }
    }






