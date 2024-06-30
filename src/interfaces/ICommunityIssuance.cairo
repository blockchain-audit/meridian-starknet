use starknet::ContractAddress;
use starknet::syscalls::emit_event_syscall;

#[starknet::interface]
trait ICommunityIssuance {
    // --- Events ---
    #[event]
    #[derive(Drop, starknet::Event)]
    fn LQTYTokenAddressSet(_lqtyTokenAddress : ContractAddress);

    #[event]
    #[derive(Drop, starknet::Event)]
    fn StabilityPoolAddressSet(_totalLQTYIssued : ContractAddress);

    #[event]
    #[derive(Drop, starknet::Event)]
    fn TotalLQTYIssuedUpdated(_totalLQTYIssued :u256);

    


    //-------  functions   --------
        #[external(V0)]
        fn setAddresses( _lqtyTokenAddress: ContractAddress,  _stabilityPoolAddress: ContractAddress) ;

        #[external(v0)]
        fn issueLQTY() -> u256;

        #[external(v0)]
        fn sendLQTY(_account: ContractAddress,  _LQTYamount: u256) ;

   

}





