
use starknet:: ContractAddress;

    // #[external(v0)]
    // --Events--
    #[event]
    #[derive(Drop, Serde, Copy, starknet::Event)]
    struct LQTYTokenAddressSet {
        _lqtyTokenAddress: ContractAddress,
    }

    #[event]
    #[derive(Drop, Serde, Copy, starknet::Event)]
     struct LockupContractDeployedThroughFactory{
        _lockupContractAddress: ContractAddress, 
        _beneficiary: ContractAddress, 
        _unlockTime: u256, 
        _deployer: ContractAddress,
    }

    enum Events {
        LockupContractDeployedThroughFactory: LockupContractDeployedThroughFactory,
        LQTYTokenAddressSet: LQTYTokenAddressSet,
    }

#[starknet::interface]
trait ILockupContractFactory {
    // --Events--

    #[event]
    #[derive(Drop, Serde, Copy, starknet::Event)]
    fn LQTYTokenAddressSet(_lqtyTokenAddress: ContractAddress);

    #[event]
    #[derive(Drop, Serde, Copy, starknet::Event)]
    fn LockupContractDeployedThroughFactory(
            _lockupContractAddress: ContractAddress, 
            _beneficiary: ContractAddress, 
            _unlockTime: u256, 
            _deployer: ContractAddress);

    // --Functions--

    #[external(v0)]
    fn setLQTYTokenAddress(_lqtyTokenAddress: ContractAddress);
    #[external(v0)]
    fn deployLockupContract(_beneficiary: ContractAddress, _unlockTime: u256);

    #[view]
    #[external(v0)]
    fn isRegisteredLockup(_addr: ContractAddress) -> bool;
}

fn main(){
    
}