#[starknet::contract]

mod TroveManager {
 use starknet::ContractAddress;
 use openzeppelin::access::ownable::library {Ownable};
 use ../interfaces::{ILQTYToken,IPriceFeed,IStabilityPool,ITroveManager};
 use trove::structs_trova_manager;
 use trove::event_trove_manager;

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

         let troveManager = TroveManager {
            borrowerOperationsAddress: _borrowerOperationsAddress,
            lqtyToken: ILQTYToken(_lqtyTokenAddress),
            stabilityPool: IStabilityPool(_stabilityPoolAddress),
            priceFeed: IPriceFeed(_priceFeedAddress),
         };
        
         let contractsCache = ContractsCache {
           activePool: IActivePool(_activePoolAddress),
           defaultPool : IDefaultPool(_defaultPoolAddress),
           lusdToken : ILUSDToken(_lusdTokenAddress),
           lqtyStaking : ILQTYStaking(_lqtyStakingAddress),
           sortedTroves :ISortedTroves(_sortedTrovesAddress),
           collSurplusPool: ICollSurplusPool(_collSurplusPoolAddress),
           gasPoolAddress: _gasPoolAddress, 
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
}