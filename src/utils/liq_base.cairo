#[starknet::library]
mod LiquityBase {


    const _100pct: u256 = 1000000000000000000;// 1e18 == 100%
    const MCR: u256 = 1100000000000000000; // 110%
    const CCR: u256 = 1500000000000000000; // 150%
    const LUSD_GAS_COMPENSATION: u256 = 2100760; // 200e18; ???
    const MIN_NET_DEBT: u256 = 25169432; // 1800e18; ???
    const PERCENT_DIVISOR: u256 = 200; // dividing by 200 yields 0.5%
    const DECIMAL_PRECISION: u256 = 1000000000000000000; // 1e18
    const BORROWING_FEE_FLOOR: u256 = 5000000000000000; // 0.5%

    // IActivePool activePool;
    // IDefaultPool defaultPool;
    // IPriceFeed priceFeed;

    fn main() { }

    #[generate_trait]
    fn _getCompositeDebt(debt: u256) -> u256 {
        debt + LUSD_GAS_COMPENSATION // debt.add(LUSD_GAS_COMPENSATION)
    }
    
    #[generate_trait]
    fn _getNetDebt(debt: u256) -> u256 {
        debt - LUSD_GAS_COMPENSATION; // debt.sub(LUSD_GAS_COMPENSATION);
    }

}
