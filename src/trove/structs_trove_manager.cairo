#[starknet::contract] 
use array::ArrayTrait;
use starknet::ContractAddress;
mod StructTroveManager { 
    ///Structs
    #[storage] 
    struct Trove {
        debt: felt252,
        coll felt252,
        arrayIndex :felt252,
        stake: felt252,
        //צריך לבדוק ססטוס 
        // Status status;
    }
    //   Object containing the STARK and LUSD snapshots for a given active trove
    #[storage] 
    struct RewardSnapshot {
        STARK :felt252,
        LUSDDebt:felt252,
    }
    #[storage] 
        struct LocalVariables_OuterLiquidationFunction {
        price :felt252,
        LUSDInStabPool :felt252,
        recoveryModeAtStart: bool,
        liquidatedDebt:felt252,
        liquidatedColl:felt252,
    }
    #[storage] 
    struct LocalVariables_InnerSingleLiquidateFunction {
        collToLiquidate :felt252,
        pendingDebtReward :felt252,
        pendingCollReward :felt252,
    }
    #[storage] 
       struct LocalVariables_LiquidationSequence {
        remainingLUSDInStabPool :felt252,
        i :felt252,
        ICR :felt252,
        userAddress :ContractAddress,
        backToNormalMode :bool,
        entireSystemDebt:felt252,
        entireSystemColl:felt252,
    }
    #[storage] 
        struct LiquidationValues {
        entireTroveDebt :felt252,
        entireTroveColl :felt252,
        collGasCompensation :felt252,
        LUSDGasCompensation :felt252,
        debtToOffset :felt252,
        collToSendToSP :felt252,
        debtToRedistribute :felt252,
        collToRedistribute :felt252,
        collSurplus :felt252,
    }
    #[storage] 
     struct LiquidationTotals {
     totalCollInSequence:felt252,
     totalDebtInSequence:felt252,
     totalCollGasCompensation:felt252,
     totalLUSDGasCompensation:felt252,
     totalDebtToOffset:felt252,
     totalCollToSendToSP:felt252,
     totalDebtToRedistribute:felt252,
     totalCollToRedistribute:felt252,
     totalCollSurplus:felt252,
    }
    #[storage] 
        struct ContractsCache {
        activePool:IActivePool,
        defaultPool:IDefaultPool,
        lusdToken :ILUSDToken,
        lqtyStaking:ILQTYStaking,
        sortedTroves:ISortedTroves,
        collSurplusPool:ICollSurplusPool,
        gasPoolAddress:ContractAddress,
    }
    #[storage] 
    struct RedemptionTotals {
        remainingLUSD: felt252,
        totalLUSDToRedeem: felt252,
        totalSTARKDrawn: felt252,
        STARKFee: felt252,
        STARKToSendToRedeemer: felt252,
        decayedBaseRate: felt252,
        price: felt252,
        totalLUSDSupplyAtStart: felt252,
    }
    #[storage] 
    struct SingleRedemptionValues {
        LUSDLot:felt252,
        STARKLot :felt252,
        cancelledPartial:bool,
    }
}
