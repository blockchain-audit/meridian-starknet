use starknet::ContractAddress;
use openzeppelin::token::erc20::{IERC20};

#[starknet::interface]
pub trait ILQTYToken<TContractState> {
    @external
    fn sendToLQTYStaking(ref self: TContractState, _sender:felt,_amount:u256 );
    @external
    fn getDeploymentStartTime( self: @TContractState)-> felt;
    @external
    fn getLpRewardsEntitlement( self: @TContractState)-> felt;

    //events
    @event
    fn CommunityIssuanceAddressSet(felt:_communityIssuanceAddress);
    @event
    fn LQTYStakingAddressSet(felt:_lqtyStakingAddress);
    @event
    fn LockupContractFactoryAddressSet(felt:_lockupContractFactoryAddress);
}

