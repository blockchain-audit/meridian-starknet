#[starknet::contract]
mod BorrowerOperations {
    use starknet::{ContractAddress, get_caller_address};
    #[derive(Copy, Drop)]
    struct LocalVariables_adjustTrove {
        price: u256,
        collChange: u256,
        netDebtChange: u256,
        isCollIncrease: bool,
        debt: u256,
        coll: u256,
        oldICR: u256,
        newICR: u256,
        newTCR: u256,
        LUSDFee: u256,
        newDebt: u256,
        newColl: u256,
        stake: u256,
    }

    #[derive(Copy, Drop)]
    struct LocalVariables_openTrove {
        price: u256,
        LUSDFee: u256,
        netDebt: u256,
        compositeDebt: u256,
        ICR: u256,
        NICR: u256,
        stake: u256,
        arrayIndex: u256,
    }

    #[derive(Copy, Drop)]
    struct ContractsCache {
        troveManager: u256,
        activePool: u256,
        lusdToken: u256,
    }

    enum BorrowerOperation {
        openTrove,
        closeTrove,
        adjustTrove
    }

    #[external]
    fn claimCollateral() {
        let caller = get_caller_address();
        collSurplusPool.claimColl(caller);
    }
}
