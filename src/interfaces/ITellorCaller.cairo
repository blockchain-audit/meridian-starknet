#[starknet::interface]
trait ITellorCaller<TContractState> {
    fn getTellorCurrentValue(self: @TContractState, _requestId:u256) -> (bool,u256, u256);
}