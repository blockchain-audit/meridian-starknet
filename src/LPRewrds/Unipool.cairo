
#[starknet::interface]
trait Event<T> {
    fn append_keys_and_data(self: T, ref keys: Array<felt252>, ref data: Array<felt252>);
    fn deserialize(ref keys: Span<felt252>, ref data: Span<felt252>) -> Option<T>;
}

#[starknet::contract]
mod Unipool {
    #[storage_var]
    pub duration:u256,
    pub periodFinish:u256,
    pub rewardRate:u256,
    pub lastUpdateTime:u256,
    pub rewardPerTokenStored:u256,
    pub userRewardPerTokenPaid: Map<felt, u256>,
    pub rewards: Map<felt, u256>

    #[event]
    #[derive(Drop, starknet::Event)]
    enum LQTYTokenAddressChanged {
        _lqtyTokenAddress:felt
    }

    enum UniTokenAddressChanged {
        _uniTokenAddress:felt
    }

    struct Staked {
        #[key]
        user: felt,
        amount: u256,
    }

    struct Withdrawn{
        #[key]
        user:felt,
        amount:u256
    }

    struct RewardPaid{
        #[key]
        user:felt,
        reward:u256
    }

    #[abi(embed_v0)]
    impl Unipool of super::IUnipool<ContractState> {
        //initialization function
        fn setParams(_lqtyTokenAddress:felt,_uniTokenAddress:felt,_duration:felt){
            self.uniToken=
        }
    }
}