#[starknet::interface]
trait IPriceFeed {
    
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        LastGoodPriceUpdated: LastGoodPriceUpdated
    }
    #[derive(Drop, starknet::Event)]
    struct LastGoodPriceUpdated{
     lastGoodPrice: u256
    }

    #[external(v0)]
    fn fetchPrice() -> u256;
}