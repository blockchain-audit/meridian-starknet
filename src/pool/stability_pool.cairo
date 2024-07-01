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
#[view]
fn _requireUserHasETHGain(_depositor:ContractAddress)  {
    let ETHGain:u256 = getDepositorETHGain(_depositor);
    assert(ETHGain > 0, "StabilityPool: caller must have non-zero ETH Gain");  
}
#[view]
fn _requireFrontEndNotRegistered(_address:ContractAddress)  {
    assert(!frontEnds[_address].registered, "StabilityPool: must not already be a registered front end");
}
#[view]
fn _requireFrontEndIsRegisteredOrZero(_address:ContractAddress)  {
    assert(
        frontEnds[_address].registered || _address == address(0),
        "StabilityPool: Tag must be a registered front end, or the zero address"
    );
}

function _requireValidKickbackRate(_kickbackRate:u256) {
    assert(_kickbackRate <= DECIMAL_PRECISION, "StabilityPool: Kickback rate must be in range [0,1]");
}


