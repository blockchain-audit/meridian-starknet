#[view]
fn _requireCallerIsActivePool(self: @ContractState) {
    assert(msg.sender == ContractAddress(activePool), "StabilityPool: Caller is not ActivePool");
}
#[view]
fn _requireCallerIsTroveManager(self: @ContractState) {
    assert(
        msg.sender == ContractAddress(troveManager), "StabilityPool: Caller is not TroveManager"
    );
}

fn _requireNoUnderCollateralizedTroves() {
    let mut price: u256 = priceFeed.fetchPrice();
    let mut lowestTrove: ContractAddress = sortedTroves.getLast();
    let mut ICR: u256 = troveManager.getCurrentICR(lowestTrove, price);
    assert(ICR >= MCR, "StabilityPool: Cannot withdraw while there are troves with ICR < MCR");
}

fn _requireUserHasDeposit(initialDeposit: u256) {
    assert(initialDeposit > 0, "StabilityPool: User must have a non-zero deposit");
}

fn _requireUserHasDeposit(initialDeposit: u256) {
    assert(initialDeposit > 0, "StabilityPool: User must have a non-zero deposit");
}

fn _requireNonZeroAmount(amount: u256) {
    assert(amount > 0, "StabilityPool: Amount must be non-zero");
}
#[view]
fn _requireUserHasTrove(self: @ContractState, depositor: ContractAddress) {
    assert(
        troveManager.getTroveStatus(depositor) == 1,
        "StabilityPool: caller must have an active trove to withdraw ETHGain to"
    );
}
