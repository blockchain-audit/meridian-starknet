<<<<<<< HEAD
use starknet::ContractAddress;
#[starknet::interface]

trait ISortedTroves<TContractState> {
    // --- Events ---
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        SortedTrovesAddressChanged: SortedTrovesAddressChanged,
        BorrowerOperationsAddressChanged: BorrowerOperationsAddressChanged,
        NodeAdded: NodeAdded,
        NodeRemoved: NodeRemoved
    }

    #[derive(Drop, starknet::Event)]
    struct SortedTrovesAddressChanged{
        sortedDoublyLLAddress: ContractAddress
    }

    #[derive(Drop, starknet::Event)]
    struct BorrowerOperationsAddressChanged{
        borrowerOperationsAddress: ContractAddress
    }

    #[derive(Drop, starknet::Event)]
    struct NodeAdded{
        id: ContractAddress,
        NICR: u256
    }

    #[derive(Drop, starknet::Event)]
    struct NodeRemoved{
        id: ContractAddress
    }

    // --- Functions ---

    fn setParams(ref self: TContractState, size: u256, TroveManagerAddress: ContractAddress, borrowerOperationsAddress: ContractAddress) external;

    fn insert(ref self: TContractState, id: ContractAddress, ICR: u256, prevId: ContractAddress, nextId: ContractAddress) external;

    fn remove(ref self: TContractState, id: ContractAddress) external;

    fn reInsert(ref self: TContractState, id: ContractAddress, newICR: u256, prevId: ContractAddress, nextId: ContractAddress) external;

    fn contains(self: @TContractState, id: ContractAddress) -> (bool) ;

    fn isFull(self: @TContractState) -> (bool);

    fn isEmpty(self: @TContractState) -> (bool)  ;
    
    fn getSize(self: @TContractState) -> (u256) ;

    fn getMaxSize(self: @TContractState) -> (u256);

    fn getFirst(self: @TContractState) -> (ContractAddress) ;

    fn getLast(self: @TContractState)-> ContractAddress ;

    fn getNext(self: @TContractState, id: ContractAddress) -> ContractAddress ;

    fn getPrev(self: @TContractState, id: ContractAddress) -> ContractAddress ;

    fn validInsertPosition(self: @TContractState, ICR: u256, prevId: ContractAddress, nextId:ContractAddress) -> bool;

    fn findInsertPosition(self: @TContractState, ICR: u256, prevId: ContractAddress, nextId: ContractAddress) -> (ContractAddress,ContractAddress);
}
=======

>>>>>>> ffb5a7f4594cbcab6318073023ca09d357501dcd
