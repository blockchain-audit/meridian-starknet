#[starknet::interface]
trait ILPTokenWrapper<TContractState> {
    fn stake(amount: u256);
    fn withdraw(amount: u256);
    fn totalSupply() -> u256;
    fn balanceOf(account: felt) -> u256;
}