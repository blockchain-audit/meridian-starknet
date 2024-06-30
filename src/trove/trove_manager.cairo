use starknet::ContractAddress;
use starknet::syscalls::storage_read;
use starknet::syscalls::storage_write;


fn _removeStake( _borrower:felt252)  {


    let stake = storage_read(_borrower);
    totalStakes = totalStakes - stake;
    storage_write(borrower, 0);

}