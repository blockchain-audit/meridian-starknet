use starknet::ContractAddress;
use openzeppelin::token::erc20::{IERC20};

#[starknet::interface]
pub trait ILQTYToken<TContractState> {
    
    fn sendToLQTYStaking(ref self: TContractState, _sender:felt,_amount:u256 );
    
    fn getDeploymentStartTime( ref self: @TContractState)-> felt;
    
    fn getLpRewardsEntitlement( ref self: @TContractState)-> felt;

    //events
    fn CommunityIssuanceAddressSet(felt:_communityIssuanceAddress);
    fn LQTYStakingAddressSet(felt:_lqtyStakingAddress);
    fn LockupContractFactoryAddressSet(felt:_lockupContractFactoryAddress);
}

