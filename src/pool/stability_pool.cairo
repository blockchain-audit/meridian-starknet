
    #[view]
    fn _requireCallerIsActivePool(self: @ContractState)   {
        assert(msg.sender == ContractAddress(activePool), "StabilityPool: Caller is not ActivePool");
    }
    #[view]
    fn _requireCallerIsTroveManager(self: @ContractState)   {
        assert(msg.sender == ContractAddress(troveManager), "StabilityPool: Caller is not TroveManager");
    }

    fn _requireNoUnderCollateralizedTroves()  {
         price :u256 = priceFeed.fetchPrice();
         lowestTrove : ContractAddress = sortedTroves.getLast();
         ICR :u256 = troveManager.getCurrentICR(lowestTrove, price);
        assert(ICR >= MCR, "StabilityPool: Cannot withdraw while there are troves with ICR < MCR");
    }