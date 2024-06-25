#[starknet::contract]
use debug::PrintTrait;

mod LiquityMath {

const DECIMAL_PRECISION = 10**18
const NICR_PRECISION = 10**20

    fn _min(a: u56, b: u256) -> u256{ 
       if a < b { 
          a; 
       } else { 
            b; 
       }
    }

    fn _max(a: u256, b: u256) -> u256{ 
       if a > b { 
          a; 
        } else { 
           b; 
        }
    }

    fn decMul(x:u256, y: u256) -> u256{ 
       let mul:u256 = x * y;  
       let decProd:u256 = mul.add(DECIMAL_PRECISION / 2).div(DECIMAL_PRECISION);
       decProd; 
    }

    fn decPow(base: u256, mut minutes: u256) -> u256{ 
        if minutes > 525600000 { 
           minutes = 525600000; 
        } 
        if minutes == 0 { 
           DECIMAL_PRECISION; 
        }
        let mut y = DECIMAL_PRECISION, 0; 
        let mut x = base; 
        let mut n = minutes;
        loop {
            if n < 1 {
               break();
            } else{   
                if n % 2 == 0 { 
                  x = decMul(x, x); 
                  n = n.div(2); 
                   
                } else { 
                   y = decMul(x, y);
                   x = decMul(x, x); 
                   n = (n.sub(1)).div(2); 
                   }      
              }
       decMul(x,y); 
    }
    fn g_etAbsoluteDifference(a: u256, b: u256) -> u256{ 
       if a >= b{ 
         a.sub(b);
        }else { 
          b.sub(a); 
        }
    }

    fn computeNominalCR(coll: u256, debt: u256) -> u256{ 
        if debt > 0 { 
          coll.mul(NICR_PRECISION).div(debt);
        } else { 
             2 ** 256 - 1;
        }
    }

    fn computeCR(coll: u256, debt: u256, price: u256) -> u256{ 
       if debt == 0 { 
          
             newCollRatio:uint256 = coll.mul(price).div(_debt)
             newCollRatio
        } else { 
             2 ** 256 - 1;
        }
    }

}
