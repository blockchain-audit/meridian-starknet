// //     // --- Dependency setter ---

// function setAddresses(
    //         address _borrowerOperationsAddress,
    //         address _activePoolAddress,
    //         address _defaultPoolAddress,
    //         address _stabilityPoolAddress,
    //         address _gasPoolAddress,
    //         address _collSurplusPoolAddress,
    //         address _priceFeedAddress,
    //         address _lusdTokenAddress,
    //         address _sortedTrovesAddress,
    //         address _lqtyTokenAddress,
    //         address _lqtyStakingAddress
    //     ) external override onlyOwner {
    //         checkContract(_borrowerOperationsAddress);
    //         checkContract(_activePoolAddress);
    //         checkContract(_defaultPoolAddress);
    //         checkContract(_stabilityPoolAddress);
    //         checkContract(_gasPoolAddress);
    //         checkContract(_collSurplusPoolAddress);
    //         checkContract(_priceFeedAddress);
    //         checkContract(_lusdTokenAddress);
    //         checkContract(_sortedTrovesAddress);
    //         checkContract(_lqtyTokenAddress);
    //         checkContract(_lqtyStakingAddress);
    
    //         borrowerOperationsAddress = _borrowerOperationsAddress;
    //         activePool = IActivePool(_activePoolAddress);
    //         defaultPool = IDefaultPool(_defaultPoolAddress);
    //         stabilityPool = IStabilityPool(_stabilityPoolAddress);
    //         gasPoolAddress = _gasPoolAddress;
    //         collSurplusPool = ICollSurplusPool(_collSurplusPoolAddress);
    //         priceFeed = IPriceFeed(_priceFeedAddress);
    //         lusdToken = ILUSDToken(_lusdTokenAddress);
    //         sortedTroves = ISortedTroves(_sortedTrovesAddress);
    //         lqtyToken = ILQTYToken(_lqtyTokenAddress);
    //         lqtyStaking = ILQTYStaking(_lqtyStakingAddress);
    
    //         emit BorrowerOperationsAddressChanged(_borrowerOperationsAddress);
    //         emit ActivePoolAddressChanged(_activePoolAddress);
    //         emit DefaultPoolAddressChanged(_defaultPoolAddress);
    //         emit StabilityPoolAddressChanged(_stabilityPoolAddress);
    //         emit GasPoolAddressChanged(_gasPoolAddress);
    //         emit CollSurplusPoolAddressChanged(_collSurplusPoolAddress);
    //         emit PriceFeedAddressChanged(_priceFeedAddress);
    //         emit LUSDTokenAddressChanged(_lusdTokenAddress);
    //         emit SortedTrovesAddressChanged(_sortedTrovesAddress);
    //         emit LQTYTokenAddressChanged(_lqtyTokenAddress);
    //         emit LQTYStakingAddressChanged(_lqtyStakingAddress);
    
    //         _renounceOwnership();
    //     }
    