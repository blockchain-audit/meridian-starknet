#[starknet::library]

mod LiquityMath {

    const DECIMAL_PRECISION: u256 = 1000000000000000000; // = 1e18
    const NICR_PRECISION: u256 = 1000000000000000000; // = e1e20
    
    fn main() {
    }

    #[generate_trait]
    fn _min(a: u256, b:u256) -> u256 {
        if a < b {
            a
        }   
        else {
            b
        }          
    }

    #[generate_trait]
    fn _max(a: u256, b:u256) -> u256 {
        if a >= b {
            a
        }
        else {
            b
        }          
    }

    
}