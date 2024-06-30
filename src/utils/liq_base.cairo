mod LiquityBase {
    const _100pct: u256 = 1000000000000000000;// 1e18 == 100%
    const MCR: u256 = 1100000000000000000; // 110%
    const CCR: u256 = 1500000000000000000; // 150%
    const LUSD_GAS_COMPENSATION: u256 = 200e18;
    const MIN_NET_DEBT: u256 = 1800e18;
    const PERCENT_DIVISOR: u256 = 200; // dividing by 200 yields 0.5%
    const BORROWING_FEE_FLOOR: u256 = DECIMAL_PRECISION / 1000 * 5; // 0.5%

    IActivePool activePool;

    IDefaultPool defaultPool;

    IPriceFeed priceFeed;
}
