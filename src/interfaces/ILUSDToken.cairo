
use starknet::ContractAddress;
// use starknet::syscalls::emit_event_syscall;
// use openzeppelin::token::erc20::{IERC20};
// use openzeppelin::IERC20;
// from openzeppelin.token import ERC20
// use openzeppelin::token::erc20::IERC20;
use openzeppelin::token::erc20::{IERC20};
#[starknet::interface]

trait ILUSDToken {

    #[external(v0)]
    fn mint(_account: ContractAddress, _amount: u256);

    #[external(v0)]
    fn burn(_account: ContractAddress, _amount: u256);


    #[external(v0)]
    fn sendToPool(_sender: ContractAddress, poolAddress: ContractAddress, _amount: u256);

    #[external(v0)]
    fn returnFromPool(poolAddress: ContractAddress, user: ContractAddress, _amount: u256);
}
  
#[event]
#[derive(Drop, starknet::Event)]
enum Event {
   TroveManagerAddressChanged: TroveManagerAddressChanged,
   StabilityPoolAddressChanged: StabilityPoolAddressChanged,
   BorrowerOperationsAddressChanged: BorrowerOperationsAddressChanged,
   LUSDTokenBalanceUpdated: LUSDTokenBalanceUpdated,
}
#[derive(Drop, starknet::Event)]
struct TroveManagerAddressChanged {
   _troveManagerAddress: ContractAddress,
}

#[derive(Drop, starknet::Event)]
struct StabilityPoolAddressChanged {
    _newStabilityPoolAddress: ContractAddress,
}

#[derive(Drop, starknet::Event)]
struct BorrowerOperationsAddressChanged {
    _newBorrowerOperationsAddress: ContractAddress,
}

 #[derive(Drop, starknet::Event)]
struct LUSDTokenBalanceUpdated {
    _user: ContractAddress,
    _amount: u256,
}
mod LUSDToken {
    use openzeppelin::token::erc20::IERC20; 
}

impl Lj of ILUSDToken {
    fn mint(_account: ContractAddress, _amount: u256){
    //    let ll: u256 = 10;
    }

    fn burn(_account: ContractAddress, _amount: u256){
        // let ll: u256 = 10;
    }

    fn sendToPool(_sender: ContractAddress, poolAddress: ContractAddress, _amount: u256){
        // let ll: u256 = 10;
    }

    fn returnFromPool(poolAddress: ContractAddress, user: ContractAddress, _amount: u256){
        // let ll: u256 = 10;
    }
}
fn main(){
    
}
