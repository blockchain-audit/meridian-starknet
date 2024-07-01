use starknet::ContractAddress;

#[starknet::interface]
trait ILQTYStaking<TContractState> {
    #[external(v0)]
    fn setAddresses(
        ref self: TContractState,
        _lqtyTokenAddress: ContractAddress,
        _lusdTokenAddress: ContractAddress,
        _troveManagerAddress: ContractAddress,
        _borrowerOperationsAddress: ContractAddress,
        _activePoolAddress: ContractAddress
    );
    #[external(v0)]
    fn stake(ref self: TContractState, _LQTYamount: felt252);
    #[external(v0)]
    fn unstake(ref self: TContractState, _LQTYamount: felt252);
    #[external(v0)]
    fn increaseF_ETH(_ETHFee: felt252);
    #[external(v0)]
    fn increaseF_LUSD(_LQTYFee: felt252);
    #[external(v0)]
    #[view]
    fn getPendingETHGain(_user: ContractAddress) -> felt252;

    #[external(v0)]
    #[view]
    fn getPendingLUSDGain(_user: ContractAddress) -> felt252;
}

#[event]
#[derive(Drop, starknet::Event)]
enum Event {
    LQTYTokenAddressSet: LQTYTokenAddressSet,
    LUSDTokenAddressSet: LUSDTokenAddressSet,
    TroveManegerAddressSet: TroveManagerAddressSet,
    BorrowerOperatiunsAddressSet: BorrowerOperationsAddressSet,
    ActivePoolAddressSet: ActivePoolAddressSet,
    StakeChanged: StakeChanged,
    StakingGainsWithdrawn: StakingGainsWithdrawn,
    FETHUpdated: FETHUpdated,
    FLUSDUpdated: FLUSDUpdated,
    TotalLQTYStakedUpdated: TotalLQTYStakedUpdated,
    EtherSent: EtherSent,
    StakerSnapshotsUpdated: StakerSnapshotsUpdated,
}

#[derive(Drop, starknet::Event)]
struct LQTYTokenAddressSet {
    _lqtyTokenAddress: ContractAddress
}
#[derive(Drop, starknet::Event)]
struct LUSDTokenAddressSet {
    _lusdTokenAddress: ContractAddress
}
#[derive(Drop, starknet::Event)]
struct TroveManagerAddressSet {
    _troveManager: ContractAddress
}
#[derive(Drop, starknet::Event)]
struct BorrowerOperationsAddressSet {
    _borrowerOperationsAddress: ContractAddress
}
#[derive(Drop, starknet::Event)]
struct ActivePoolAddressSet {
    _activePoolAddress: ContractAddress
}
#[derive(Drop, starknet::Event)]
struct StakeChanged {
    staker: ContractAddress,
    newStake: felt252
}
#[derive(Drop, starknet::Event)]
struct StakingGainsWithdrawn {
    staker: ContractAddress,
    LUSDGain: felt252,
    ETHGain: felt252
}
#[derive(Drop, starknet::Event)]
struct F_ETHUpdated {
    _F_ETH: felt252
}
#[derive(Drop, starknet::Event)]
struct F_LUSDUpdated {
    _F_LUSD: felt252
}
#[derive(Drop, starknet::Event)]
struct TotalLQTYStakedUpdated {
    _totalLQTYStaked: felt252
}
#[derive(Drop, starknet::Event)]
struct EtherSent {
    _account: ContractAddress,
    _amount: felt252
}
#[derive(Drop, starknet::Event)]
struct StakerSnapshotsUpdated {
    _staker: ContractAddress,
    _F_ETH: felt252,
    _F_LUSD: felt252
}
