#[starknet::contract]
mod collSurplusPool{
use starknet::ContractAddress;

#[external]
fn claimColl(_account:ContractAddress){
    _requireCallerIsBorrowerOperations();
    let claimablecoll: felt252 = balances[_account];
    assert(claimableColl>0, "CollSurplusPool: No collateral available to claim");
    balances[_account] = 0;
    self.emit(CollBalanceUpdated { _account: _account, _newBalance: 0 });
    STARK = STARK.sub(claimableColl);
    emit EtherSent(_to: _account, _amount: claimableColl);
    let (success, ) = _account.call{value: claimableColl};
    assert(success, "CollSurplusPool: sending STARK failed");
}

}