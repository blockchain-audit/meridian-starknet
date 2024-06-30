<<<<<<< HEAD
#[starknet::interface]
trait IRewardsPool<TContractState> {
    fn setParams(self: TContractState, _lqtyTokenAddress: felt252,  _uniTokenAddress: felt252, _duration: u256);
    fn lastTimeRewardApplicable(self: TContractState) -> u256;
    fn rewardPerToken(self: TContractState) -> u256;
    fn earned(self: TContractState, account: felt252) -> u256;
    fn withdrawAndClaim(self: TContractState);
    fn claimReward(self: TContractState);
}

=======
#[starknet::interface]
trait IRewardsPool<TContractState> {
    fn setParams(
        self: TContractState, _lqtyTokenAddress: felt252, _uniTokenAddress: felt252, _duration: u256
    );
    fn lastTimeRewardApplicable(self: TContractState) -> u256;
    fn rewardPerToken(self: TContractState) -> u256;
    fn earned(self: TContractState, account: felt252) -> u256;
    fn withdrawAndClaim(self: TContractState);
    fn claimReward(self: TContractState);
}
>>>>>>> ffb5a7f4594cbcab6318073023ca09d357501dcd
