%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
//from starkware.cairo.common.cairo_builtins import HashBuiltin
// from starkware.cairo.common.cairo_builtins import HashBuiltin
// from starkware.cairo.common.syscalls import get_caller_address
// use starknet::ContractAddress;
// use openzeppelin::access::ownable::library {Ownable};
//{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}
fn setAddresses(
    ContractAddress _borrowerOperationsAddress,
    ContractAddress _activePoolAddress,
    ContractAddress _defaultPoolAddress,
    ContractAddress _stabilityPoolAddress,
    ContractAddress _gasPoolAddress,
    ContractAddress _collSurplusPoolAddress,
    ContractAddress _priceFeedAddress,
    ContractAddress _lusdTokenAddress,
    ContractAddress _sortedTrovesAddress,
    ContractAddress _lqtyTokenAddress,
    ContractAddress _lqtyStakingAddress)
    {
     
        //assert_only_owner();
     borrowerOperationsAddress = _borrowerOperationsAddress;
     activePool = IActivePool(_activePoolAddress);
     defaultPool = IDefaultPool(_defaultPoolAddress);
     stabilityPool = IStabilityPool(_stabilityPoolAddress);
     gasPoolAddress = _gasPoolAddress;
     collSurplusPool = ICollSurplusPool(_collSurplusPoolAddress);
     priceFeed = IPriceFeed(_priceFeedAddress);
     lusdToken = ILUSDToken(_lusdTokenAddress);
     sortedTroves = ISortedTroves(_sortedTrovesAddress);
     lqtyToken = ILQTYToken(_lqtyTokenAddress);
     lqtyStaking = ILQTYStaking(_lqtyStakingAddress);

     self.emit BorrowerOperationsAddressChanged(_borrowerOperationsAddress);
     self.emit ActivePoolAddressChanged(_activePoolAddress);
     self.emit DefaultPoolAddressChanged(_defaultPoolAddress);
     self.emit StabilityPoolAddressChanged(_stabilityPoolAddress);
     self.emit GasPoolAddressChanged(_gasPoolAddress);
     self.emit CollSurplusPoolAddressChanged(_collSurplusPoolAddress);
     self.emit PriceFeedAddressChanged(_priceFeedAddress);
     self.emit LUSDTokenAddressChanged(_lusdTokenAddress);
     self.emit SortedTrovesAddressChanged(_sortedTrovesAddress);
     self.emit LQTYTokenAddressChanged(_lqtyTokenAddress);
     self.emit LQTYStakingAddressChanged(_lqtyStakingAddress);
      
   //  renounce_ownership();

}