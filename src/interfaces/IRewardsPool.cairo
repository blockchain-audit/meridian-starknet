#[starknet::interface]
trait IUnipool<TContractState> {
    fn setParams(_lqtyTokenAddress:felt,  _uniTokenAddress:felt, _duration:u256);
    fn lastTimeRewardApplicable() -> (u256);
    fn rewardPerToken() -> (u256);
    fn earned(address account) -> (u256);
    fn withdrawAndClaim();
    fn claimReward();
}