// // renamed from unipool

// use openzeppelin::token::erc20::{IERC20};

// use starknet::ContractAddress;

// use interfaces::{ILPTokenWrapper,IUnipool};

// use ../interfaces::{ILQTYToken};

// #[starknet::interface]
// trait Event<T> {
//     fn append_keys_and_data(self: T, ref keys: Array<felt252>, ref data: Array<felt252>);
//     fn deserialize(ref keys: Span<felt252>, ref data: Span<felt252>) -> Option<T>;
// }

// #[starknet::contract]
// mod LPTokenWrapper {

//     use starknet::{ get_contract_address, get_caller_address, storage_access::StorageBaseAddress };

//     #[storage]
//     struct Storage {
//         _totalSupply: u256,
//         _balances: LegacyMap::<felt, u256>,
//         // uniToken: IERC20
//         uniTokenAddress := contract_address(IERC20)
//     }

//     #[abi(embed_v0)]
//     impl LPTokenWrapper of super::ILPTokenWrapper<ContractState> {
//         fn totalSupply() -> u256 {
//             self._totalSupply.read();
//         }

//         fn balanceOf(account: felt) -> u256 {
//             self._balances.read(account);
//         }

//         fn stake(amount: u256) {
//             self._totalSupply.write(totalSupply() + amount);
//             let sender: felt = get_caller_address();
//             self._balances.write(balanceOf(sender) + amount);
//             // uniToken.transferFrom(sender, get_contract_address(), amount);
//            library_call_IERC20(self.uniTokenAddress.read()).transferFrom(sender, get_contract_address(), amount);
//         }

//         fn withdraw(amount: u256) {
//             self._totalSupply.write(totalSupply() - amount);
//             let recipient: felt = get_caller_address();
//             self._balances.write(balanceOf(recipient) - amount);
//             uniToken.transfer(recipient, amount);
//         }
//     }
// }

// #[starknet::contract]
// mod Unipool of super::IUnipool<ContractState> {

//     #[storage_var]
//     struct storage{
// }

//     let mut duration:u256,
//     let mut lqtyToken:ILQTYToken,
//     let mut periodFinish:u256,
//     let mut rewardRate:u256,
//     let mut lastUpdateTime:u256,
//     let mut rewardPerTokenStored:u256,
//     let mut userRewardPerTokenPaid: Map<felt, u256>,
//     let mut rewards: Map<felt, u256>

//     #[event]
//     #[derive(Drop, starknet::Event)]
//     enum LQTYTokenAddressChanged {
//         _lqtyTokenAddress: felt
//     }

//     enum UniTokenAddressChanged {
//         _uniTokenAddress: felt
//     }

//     struct Staked {
//         #[key]
//         user: felt,
//         amount: u256,
//     }

//     struct Withdrawn {
//         #[key]
//         user: felt,
//         amount: u256
//     }

//     struct RewardPaid {
//         #[key]
//         user:felt,
//         reward:u256
//     }

//     #[abi(embed_v0)]
//     impl Unipool of super::IUnipool<ContractState> {

//         //initialization function
//         fn setParams(_lqtyTokenAddress:felt,_uniTokenAddress:felt,_duration:felt){
//             self.uniToken.write(IERC20(_uniTokenAddress));
//             self.lqtyToken.write(IERC20(_lqtyTokenAddress));

//         }
//     }
// }


