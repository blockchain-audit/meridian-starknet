#[starknet::interface] :
trait ILQTYToken { 
    use openzeppelin::token::erc20::{IERC20};
    use starknet::ContractAddress;
    
     fn sendToLQTYStaking( _sender:felt, amount: felt252);
     fn getDeploymentStartTime() -> felt252; 
     fn getLpRewardsEntitlement() -> felt252;
     //events
     @event
     fn CommunityIssuanceAddressSet(felt:_communityIssuanceAddress);
     @event
     fn LQTYStakingAddressSet(felt:_lqtyStakingAddress);
     @event
     fn LockupContractFactoryAddressSet(felt:_lockupContractFactoryAddress);


    } 
  

