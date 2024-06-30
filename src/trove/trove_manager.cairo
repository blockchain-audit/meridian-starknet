use starknet::ContractAddress;


#[external(v0)]
fn getTroveOwnersCount(self: @ContractState) -> u256 {
    return TroveOwners.length;
}

#[external(v0)]
fn getTroveFromTroveOwnersArray(self: @ContractState, index:u256) -> ContractAddress{
    return TroveOwners[index];
}