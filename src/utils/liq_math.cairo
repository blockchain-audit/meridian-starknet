#[starknet::library]
// use utils::safe_math::SafeMath;

mod LiquityMath {
    const DECIMAL_PRECISION: u256 = 1000000000000000000; // = 1e18
    const NICR_PRECISION: u256 = 1000000000000000000; // = e1e20
    
    #[generate_trait] 
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

    #[generate_trait]
    fn _decPow( _base: u256, mut _minutes: u256)->u256{

        let MAX_MINUTES: u256 = 525600000;
        let mut result: u256 = DECIMAL_PRECISION;
    
        if _minutes > MAX_MINUTES {   
            _minutes = MAX_MINUTES;
        }
        if _minutes == 0 {
            result
        }
        else {     
            let mut base:  u256 = _base;
            let mut exp: u256  = _minutes;
        
            loop {
                if exp <= 1 {
                    break();
                }
                if ( exp % 2 != 0){
                   result = decMul(base, result);
                   exp = exp - 1;
                }
                base = decMul(base, base);
                exp /= 2;
            };

            decMul(base, result)
        }
    }
}
