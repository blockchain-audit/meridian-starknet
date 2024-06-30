// import "./Interfaces/IActivePool.sol";
// import "./Dependencies/SafeMath.sol";
// import "./Dependencies/Ownable.sol";
// import "./Dependencies/CheckContract.sol";
// import "./Dependencies/console.sol";

// use starknet::ContractAddress;

// mod ActivePool is Ownable, CheckContract, IActivePool {
//     using SafeMath for uint256;

//     const NAME : felt252 = "ActivePool";

//     borrowerOperationsAddress: ContractAddress
//     troveManagerAddress: ContractAddress
//     stabilityPoolAddress: ContractAddress
//     defaultPoolAddress: ContractAddress
//     ETH: u256 // deposited ether tracker
//     LUSDDebt: u256

//     #[event]
//     #[derive(Drop, starknet::Event)]
//     enum Event{
//         BorrowerOperationsAddressChanged: BorrowerOperationsAddressChanged,
//         TroveManagerAddressChanged: TroveManagerAddressChanged,
//         ActivePoolLUSDDebtUpdated: ActivePoolLUSDDebtUpdated,
//         ActivePoolETHBalanceUpdated: ActivePoolETHBalanceUpdated
//     }

//     #[derive(Drop, starknet::Event)]
//     struct BorrowerOperationsAddressChanged {
//         newBorrowerOperationsAddress: ContractAddress
//     } 
//     #[derive(Drop, starknet::Event)]
//     struct TroveManagerAddressChanged {
//         newTroveManagerAddress: ContractAddress
//     }
//      #[derive(Drop, starknet::Event)]
//      struct ActivePoolLUSDDebtUpdated { 
//         LUSDDebt: u256
//     }
//      #[derive(Drop, starknet::Event)]
//      struct ActivePoolETHBalanceUpdated {
//         ETH: u256
//     }

//     #[external]
//     fn setAddresses (
//          _borrowerOperationsAddress: ContractAddress,
//          _troveManagerAddress: ContractAddress,
//          _stabilityPoolAddress: ContractAddress,
//          _defaultPoolAddress: ContractAddress
//     )  onlyOwner {
//         checkContract(_borrowerOperationsAddress);
//         checkContract(_troveManagerAddress);
//         checkContract(_stabilityPoolAddress);
//         checkContract(_defaultPoolAddress);

//         borrowerOperationsAddress = _borrowerOperationsAddress;
//         troveManagerAddress = _troveManagerAddress;
//         stabilityPoolAddress = _stabilityPoolAddress;
//         defaultPoolAddress = _defaultPoolAddress;

//         emit BorrowerOperationsAddressChanged(_borrowerOperationsAddress);
//         emit TroveManagerAddressChanged(_troveManagerAddress);
//         emit StabilityPoolAddressChanged(_stabilityPoolAddress);
//         emit DefaultPoolAddressChanged(_defaultPoolAddress);

//         _renounceOwnership();
//     }

//     function getETH() external view override returns (uint256) {
//         return ETH;
//     }

//     function getLUSDDebt() external view override returns (uint256) {
//         return LUSDDebt;
//     }

//     function sendETH(address _account, uint256 _amount) external override {
//         _requireCallerIsBOorTroveMorSP();
//         ETH = ETH.sub(_amount);
//         emit ActivePoolETHBalanceUpdated(ETH);
//         emit EtherSent(_account, _amount);

//         (bool success,) = _account.call{value: _amount}("");
//         require(success, "ActivePool: sending ETH failed");
//     }

//     function increaseLUSDDebt(uint256 _amount) external override {
//         _requireCallerIsBOorTroveM();
//         LUSDDebt = LUSDDebt.add(_amount);
//         ActivePoolLUSDDebtUpdated(LUSDDebt);
//     }

//     function decreaseLUSDDebt(uint256 _amount) external override {
//         _requireCallerIsBOorTroveMorSP();
//         LUSDDebt = LUSDDebt.sub(_amount);
//         ActivePoolLUSDDebtUpdated(LUSDDebt);
//     }

//     // --- 'require' functions ---

//     function _requireCallerIsBorrowerOperationsOrDefaultPool() internal view {
//         require(
//             msg.sender == borrowerOperationsAddress || msg.sender == defaultPoolAddress,
//             "ActivePool: Caller is neither BO nor Default Pool"
//         );
//     }

//     function _requireCallerIsBOorTroveMorSP() internal view {
//         require(
//             msg.sender == borrowerOperationsAddress || msg.sender == troveManagerAddress
//                 || msg.sender == stabilityPoolAddress,
//             "ActivePool: Caller is neither BorrowerOperations nor TroveManager nor StabilityPool"
//         );
//     }

//     function _requireCallerIsBOorTroveM() internal view {
//         require(
//             msg.sender == borrowerOperationsAddress || msg.sender == troveManagerAddress,
//             "ActivePool: Caller is neither BorrowerOperations nor TroveManager"
//         );
//     }

//     // --- Fallback function ---

//     receive() external payable {
//         _requireCallerIsBorrowerOperationsOrDefaultPool();
//         ETH = ETH.add(msg.value);
//         emit ActivePoolETHBalanceUpdated(ETH);
//     }
// }


