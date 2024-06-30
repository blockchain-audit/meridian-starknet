// renamed from unipool

use openzeppelin::token::erc20::{IERC20};

use starknet::ContractAddress;

use ::interfaces::{ILPTokenWrapper,IUnipool};



#[starknet::interface]
trait Event<T> {
    fn append_keys_and_data(self: T, ref keys: Array<felt252>, ref data: Array<felt252>);
    fn deserialize(ref keys: Span<felt252>, ref data: Span<felt252>) -> Option<T>;
}

#[starknet::contract]
mod LPTokenWrapper {

    use starknet::{ get_contract_address, get_caller_address, storage_access::StorageBaseAddress };

    #[storage]
    struct Storage {
        _totalSupply: u256,
        _balances: LegacyMap::<felt, u256>,
        // uniToken: IERC20
        uniTokenAddress : contract_address
    }

    #[abi(embed_v0)]
    impl LPTokenWrapper of super::ILPTokenWrapper<ContractState> {
        fn totalSupply() -> u256 {
            self._totalSupply.read();
        }

        fn balanceOf(account: felt) -> u256 {
            self._balances.read(account);
        }

        fn stake(amount: u256) {
            self._totalSupply.write(totalSupply() + amount);
            let sender: felt = get_caller_address();
            self._balances.write(balanceOf(sender) + amount);
            // uniToken.transferFrom(sender, get_contract_address(), amount);
           library_call_IERC20(self.uniTokenAddress.read()).transferFrom(sender, get_contract_address(), amount);
        }

        fn withdraw(amount: u256) {
            self._totalSupply.write(totalSupply() - amount);
            let recipient: felt = get_caller_address();
            self._balances.write(balanceOf(recipient) - amount);
            uniToken.transfer(recipient, amount);
        }
    }
}


#[starknet::contract]
mod Unipool {

    //use ILQTYToken;   
    #[storage]
    struct Storage {
        duration:u256,
        lqtyToken:ILQTYToken,
        periodFinish:u256,
        rewardRate:u256,
        lastUpdateTime:u256,
        rewardPerTokenStored:u256,
        userRewardPerTokenPaid: Map<ContractAddress, u256>,
        rewards: Map<ContractAddress, u256>
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum LQTYTokenAddressChanged {
        _lqtyTokenAddress: ContractAddress
    }

    enum UniTokenAddressChanged {
        _uniTokenAddress: ContractAddress
    }

    struct Staked {
        #[key]
        user: ContractAddress,
        amount: u256,
    }

    struct Withdrawn {
        #[key]
        user: ContractAddress,
        amount: u256
    }

    struct RewardPaid {
        #[key]
        user:ContractAddress,
        reward:u256
    }

    struct Staked{
        #[key]
        user:ContractAddress,
        amount:u256
    }

    #[abi(embed_v0)]
    impl Unipool of super::IUnipool<ContractState> {

        #[external(v0)]
        fn setParams(_lqtyTokenAddress:ContractAddress,_uniTokenAddress:ContractAddress,_duration:ContractAddress){
            self.uniToken.write(IERC20(_uniTokenAddress));
            self.lqtyToken.write(IERC20(_lqtyTokenAddress));
            self._notifyRewardAmount(lqtyToken.getLpRewardsEntitlement(), _duration);

            self.emit(LQTYTokenAddressChanged{_lqtyTokenAddress:_lqtyTokenAddress});
            self.emit (UniTokenAddressChanged {_lqtyTokenAddress:_uniTokenAddress});

            self._renounceOwnership();
        }

        fn _notifyRewardAmount(_reward:u256,_duration:u256){
            assert _reward>0;
            assert _reward == lqtyToken.balanceOf(address(this));
            assert periodFinish == 0;
            
            let timestamp = syscalls.get_block_timestamp();
            self._updateReward();
            self.rewardRate.write((self._reward).div(_duration));
            self.lastUpdateTime.write(timestamp);
            self.periodFinish.write(timestamp);
            self.emit(RewardAdded{_reward});//Ownable
        } 

        fn earned(account: Address) -> ContractAddress {

            let balance = balanceOf(account);
            let reward_per_token = rewardPerToken();         
            
            let user_reward_per_token_paid = userRewardPerTokenPaid[account];          
           
            let numerator = mul(balance, sub(reward_per_token, user_reward_per_token_paid));
            let denominator = cast(felt, 1_000_000_000_000_000_000); // 1e18 represented as felt
            let quotient = div(numerator, denominator);         
          
            let earned_amount = add(quotient, rewards[account]);         
            return earned_amount;
        }


        fn stake(amount: felt) -> felt {
    
            // Check if amount is greater than zero
            let amount_gt_zero =lt(amount, felt(0));  //In Cairo, felt(0) represents zero
            assert(amount_gt_zero, "Cannot stake 0");

            // Check if uniToken address is not zero
            let is_uniToken_zero = eq(uniToken, FIELD_CONSTANT(0));
            assert(!is_uniToken_zero, "Liquidity Pool Token has not been set yet")

            // Call internal functions for updates (assuming they are written in Cairo)
            _updatePeriodFinish()
            _updateAccountReward(msg.sender)

           // Call parent contract's stake function (assuming "super" refers to a parent contract)
           super.stake(amount);

           self.emit(Staked{msg.sender},{amount});
        }        
    }
}