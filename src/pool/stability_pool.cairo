mod StabilityPool{
   let STARK:felt252;
   let totalLUSDDeposits:felt252;
    #[external(v0)]
    fn getTotalLUSDDeposits(self: @ContractState) -> felt252 {
        return totalLUSDDeposits;
    }
    #[external(v0)]
    fn getSTARK(self: @ContractState)  ->felt252 {
        return STARK;
    }
}