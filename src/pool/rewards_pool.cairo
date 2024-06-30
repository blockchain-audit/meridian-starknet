// renamed from unipool

// use openzeppelin::token::erc20::{IERC20};

// #[starknet::interface]
// trait Event<T> {
//     fn append_keys_and_data(self: T, ref keys: Array<felt252>, ref data: Array<felt252>);
//     fn deserialize(ref keys: Span<felt252>, ref data: Span<felt252>) -> Option<T>;
// }

use starknet::ContractAddress;
// use super::src::interfaces::ILPTokenWrapper::ILPTokenWrapper;
// use super::ILPTokenWrapper::ILPTokenWrapper;

#[starknet::interface]
trait ILPTokenWrapper<TContractState> {
    fn totalSupply(self: @TContractState) -> u256;
    fn balanceOf(self: @TContractState, account: ContractAddress) -> u256;
    fn stake(ref self: TContractState, amount: u256);
    fn withdraw(ref self: TContractState, amount: u256);
}

#[starknet::contract]
mod LPTokenWrapper {
    use starknet::ContractAddress;
    use starknet::{get_contract_address, get_caller_address, storage_access::StorageBaseAddress};

    #[storage]
    struct Storage {
        _totalSupply: u256,
        _balances: LegacyMap<ContractAddress, u256>,
    // uniToken: IERC20
    // uniTokenAddress := contract_address(IERC20)
    }

    #[abi(embed_v0)]
    impl LPTokenWrapperImpl of super::ILPTokenWrapper<ContractState> {
        fn totalSupply(self: @ContractState) -> u256 {
            self._totalSupply.read()
        }

        fn balanceOf(self: @ContractState, account: ContractAddress) -> u256 {
            self._balances.read(account)
        }

        fn stake(ref self: ContractState, amount: u256) {
            self._totalSupply.write(self.totalSupply() + amount);
            let _sender: ContractAddress = get_caller_address();
            self._balances.write(_sender, self.balanceOf(_sender) + amount);
        // uniToken.transferFrom(sender, get_contract_address(), amount);
        //    library_call_IERC20(self.uniTokenAddress.read()).transferFrom(sender, get_contract_address(), amount);
        }

        fn withdraw(ref self: ContractState, amount: u256) {
            self._totalSupply.write(self.totalSupply() - amount);
            let _recipient: ContractAddress = get_caller_address();
            self._balances.write(_recipient, self.balanceOf(_recipient) - amount);
        // uniToken.transfer(recipient, amount);
        }
    }
}

#[starknet::interface]
trait IRewardsPool<TContractState> {
    // fn setParams(
    //     ref self: TContractState,
    //     _lqtyTokenAddress: felt252,
    //     _uniTokenAddress: felt252,
    //     _duration: u256
    // );
    fn lastTimeRewardApplicable(self: @TContractState) -> u256;
// fn rewardPerToken(self: TContractState) -> u256;
// fn earned(self: TContractState, account: felt252) -> u256;
// fn withdrawAndClaim(self: TContractState);
// fn claimReward(self: TContractState);
}

#[starknet::contract]
mod Unipool {
    // #[storage_var]
    // pub duration:u256,
    // pub lqtyToken:ILQTYToken,
    // pub periodFinish:u256,
    // pub rewardRate:u256,
    // pub lastUpdateTime:u256,
    // pub rewardPerTokenStored:u256,
    // pub userRewardPerTokenPaid: Map<felt, u256>,
    // pub rewards: Map<felt, u256>
    #[storage]
    struct Storage {
        duration: u256,
        // lqtyToken:ILQTYToken,
        periodFinish: u256,
        rewardRate: u256,
        lastUpdateTime: u256,
        rewardPerTokenStored: u256,
        userRewardPerTokenPaid: LegacyMap<felt252, u256>,
        rewards: LegacyMap<felt252, u256>
    }

    // #[event]
    // #[derive(Drop, starknet::Event)]
    // enum EventLQTYTokenAddressChanged {
    //     _lqtyTokenAddress: felt252
    // }

    // #[event]
    // #[derive(Drop, starknet::Event)]
    // enum Event {
    //     _lqtyTokenAddress: felt252
    // }
    // enum UniTokenAddressChanged {
    //     _uniTokenAddress: felt
    // }

    struct Staked {
        #[key]
        user: felt252,
        amount: u256,
    }
    struct Withdrawn {
        #[key]
        user: felt252,
        amount: u256
    }

    struct RewardPaid {
        #[key]
        user: felt252,
        reward: u256
    }
    #[abi(embed_v0)]
    impl Unipool of super::IRewardsPool<ContractState> {
        //initialization function
        // fn setParams(
        //     ref self: ContractState,
        //     _lqtyTokenAddress: felt252,
        //     _uniTokenAddress: felt252,
        //     _duration: u256) {
        //     // self.uniToken.write(IERC20(_uniTokenAddress));
        //     // self.lqtyToken.write(IERC20(_lqtyTokenAddress));
        // }

        // Returns current timestamp if the rewards program has not finished yet, end time otherwise
        #[view]
        fn lastTimeRewardApplicable(self: @ContractState) -> u256 {
            // library_call_(liq_math._min(syscalls.get_block_timestamp(), self.periodFinish));
            10
        }
    //         // Returns the amount of rewards that correspond to each staked token
    //         fn rewardPerToken(ref self: @ContractState) -> u256 {
    //             if (library_call_(LPTokenWrapper.totalSupply()) == 0) {
    //                 return self.rewardPerTokenStored;
    //             }
    //             return rewardPerTokenStored.add(
    //                 self.lastTimeRewardApplicable().sub(self.lastUpdateTime).mul(self.rewardRate).mul(1e18).div(library_call_(LPTokenWrapper.totalSupply()))
    //             );
    //         }
    }
}
