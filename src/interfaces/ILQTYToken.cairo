use starknet::ContractAddress;
use openzeppelin::token::erc20::{IERC20};

#[starknet::interface]
pub trait ILQTYToken<TContractState> {
   
    fn sendToLQTYStaking(ref self: TContractState,_sender:felt, _amount:u256) ;
    
    fn getDeploymentStartTime(self: @TContractState) -> felt252 ;
    
    fn getLpRewardsEntitlement(self: @TContractState) -> felt252 ;

    fn CommunityIssuanceAddressSet(_communityIssuanceAddress:felt);

    fn LQTYStakingAddressSet(_lqtyStakingAddress:felt);

    fn LockupContractFactoryAddressSet(_lockupContractFactoryAddress:felt);
}
