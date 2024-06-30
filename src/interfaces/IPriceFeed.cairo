#[starknet::interface]
trait IPriceFeed {
    
  

    #[external(v0)]
    fn fetchPrice() -> u256;
}
#[event]
#[derive(Drop, starknet::Event)]
enum Event {
    LastGoodPriceUpdated: LastGoodPriceUpdated
}
#[derive(Drop, starknet::Event)]
struct LastGoodPriceUpdated{
 lastGoodPrice: u256
}