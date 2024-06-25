#[starknet::interface] :
trait ILQTYToken { 
    use openzeppelin::token::erc20::{IERC20};
    use starknet::ContractAddress;
     @external
     fn sendToLQTYStaking( _sender:felt, amount: felt252);
     @external
     fn getDeploymentStartTime() -> (felt252); 
     @external
     fn getLpRewardsEntitlement() -> (felt252);
     //events
     @event
     fn CommunityIssuanceAddressSet(felt:_communityIssuanceAddress);
     @event
     fn LQTYStakingAddressSet(felt:_lqtyStakingAddress);
     @event
     fn LockupContractFactoryAddressSet(felt:_lockupContractFactoryAddress);


    } 
  

