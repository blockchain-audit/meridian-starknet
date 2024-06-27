#[starknet::contract]
mod collSurplusPool{
use starknet::ContractAddress;

#[external]
fn claimColl(_account:ContractAddress){
    _requireCallerIsBorrowerOperations();
    felt252  
    let claimablecoll: felt252 = balances[_account];
    assert(claimableColl>0, "CollSurplusPool: No collateral available to claim");
    balances[_account] = 0;
    self.emit(CollBalanceUpdated { _account: _account, _newBalance: 0 });
   // ETH = ETH.sub(claimableColl);
   emit EtherSent(_to: _account, _amount: claimableColl);
   let (success, ) = _account.call{value: claimableColl}(new callData);
   assert(success, "CollSurplusPool: sending ETH failed");
}

// fn _requireCallerIsBorrowerOperations() 



function _requireCallerIsBorrowerOperations() internal view {
    require(msg.sender == borrowerOperationsAddress, "CollSurplusPool: Caller is not Borrower Operations");
}




}