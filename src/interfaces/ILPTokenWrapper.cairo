use starknet:: ContractAddress;

#[starknet::interface]
trait ILPTokenWrapper{

    #[external(v0)]
    fn stake(amount: u256 );

    #[external(v0)]
    fn withdraw(amount: u256);

    #[external(v0)]
    fn totalSupply() -> u256;

    #[external(v0)]
    fn balanceOf(account :ContractAddress) -> u256;

}
