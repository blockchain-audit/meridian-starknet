#[starknet::contract]
mod CollSurplusPool{
    //use 
    use array::ArrayTrait;

    #[storage]
    struct Storage {
        const NAME : let = "CollSurplusPool";

        let borrowerOperationsAddress;
        let troveManagerAddress;
        let activePoolAddress;

        let ETH : u256;

        let balances = ArrayTrait::new();
    }

    struct balance{
        let address;
        let balance:u256;
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        BorrowerOperationsAddressChanged: BorrowerOperationsAddressChanged,
        TroveManagerAddressChanged: TroveManagerAddressChanged;
        ActivePoolAddressChanged: ActivePoolAddressChanged;

        CollBalanceUpdated: CollBalanceUpdated;
        EtherSent: EtherSent;
    }

    #[derive(Drop, starknet::Event)]
    struct BorrowerOperationsAddressChanged{
        let _newBorrowerOperationsAddress;
    }

    #[derive(Drop, starknet::Event)]
    struct TroveManagerAddressChanged{
        let _newTroveManagerAddress;
    }  
    
    #[derive(Drop, starknet::Event)]
    struct ActivePoolAddressChanged{
        let _newActivePoolAddress;
    }


    #[derive(Drop, starknet::Event)]
    struct CollBalanceUpdated{
        let _account;
        let _newBalance: u256;
    }
    
    #[derive(Drop, starknet::Event)]
    struct EtherSent{
        let _to;
        let _amount : u256;
    }

    fn setAddress(_borrowerOperationsAddress: let, _troveManagerAddress: let, _activePoolAddress: let )
    
}