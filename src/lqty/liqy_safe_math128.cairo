
use debug::PrintTrait;

#[starknet::libary]
mod LiquitySafeMath128 {

    fn add(a: u256, b:u256 ) -> u256 {
        let c :u256 = a + b;
        assert(c >= a, 'LiquitySafeMath128: addition overflow');
        c
    }

    fn sub(u128: a, u128: b) -> u128 {
        let c :u256 = a - b;
        assert(b <= a, 'LiquitySafeMath128: subtraction overflow'); 
        c  
    }
    
}