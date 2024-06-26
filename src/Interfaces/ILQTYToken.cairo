use starknet::ContractAddress;
use openzeppelin::token::erc20::{IERC20};

#[starknet::interface]
pub trait ILQTYToken<TContractState> {
    @external
    fn sendToLQTYStaking(ref self: TContractState,_sender:felt, _amount:u256) ;
    @external
    fn getDeploymentStartTime(self: @TContractState) -> felt252 ;
    @external
    fn getLpRewardsEntitlement(self: @TContractState) -> felt252 ;

    @event
    fn CommunityIssuanceAddressSet(_communityIssuanceAddress:felt);
    @event
    fn LQTYStakingAddressSet(_lqtyStakingAddress:felt);
    @event
    fn LockupContractFactoryAddressSet(_lockupContractFactoryAddress:felt);
}







