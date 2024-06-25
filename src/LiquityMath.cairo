#[starknet::contract]
use debug::PrintTrait;

mod LiquityMath {

    //use SafeMath
    const DECIMAL_PRECISION: u256 = 15;//1e18
    const NICR_PRECISION: u256 = 15;//1e20 
    fn main() {
        
    }

    fn _min(a: u256, b:u256) -> u256 {
        if a < b {a}
          
        else {b}          
    }

    fn _max(a: u256, b:u256) -> u256 {
        if a >= b {a}

        else {b}          
    }

    fn decMul(x: u256, y: u256)-> u256{
      
      let prod_xy:u256 = x*y;//x.mul(y);
      let decProd:u256 = prod_xy+(DECIMAL_PRECISION/2)/DECIMAL_PRECISION;//.add(DECIMAL_PRECISION / 2).div(DECIMAL_PRECISION);
      decProd   
    }

    fn _decPow( base:u256, mut minutes:u256)->u256{

        if minutes > 525600000{

            minutes = 525600000;
        }        
        // if minutes == 0
        // {
        //     DECIMAL_PRECISION
        // }
        let y:u256 = DECIMAL_PRECISION;
        let x:u256 = base;
        let n:u256 = minutes;
        
        // loop{
            
        //     if n > 1{
        //         break();
        //     }
        //     if n % 2 == 0 
        //     {

        //         x = decMul(x,x);
        //        // n = n.div(2);
        //     }
        //     else{
        //         y = decMul(x,y);
        //         x = decMul(x,x);
        //         //n = (n.sub(1)).div(2);
        //     }
        // };

        //return
         decMul(x,y)
   }

   fn _getAbsoluteDifference(a:u256, b:u256)-> u256 {

        if a >= b {
            a-b
         //   a.sub(b)
        }
        else{ 

            b-a
            //b.sub(a)
        }
   }

   fn _computeNominalCR(coll:u256, debt:u256) -> u256 {

        if debt > 0 {
           
           (coll*NICR_PRECISION)/debt
           //coll.mul(NICR_PRECISION).div(debt);
        }
       
        else {
           
             2 ** 256 - 1;
        }
    }

    fn _computeCR(coll:u256, debt:u256, price:u256)-> u256 {
       
        if debt > 0 {
            newCollRatio:u256 =coll*price/debt; //coll.mul(price).div(debt);        
            newCollRatio
        }
        // Return the maximal value for uint256 if the Trove has a debt of 0. Represents "infinite" CR.
        else {
            // if (_debt == 0)
             2 ** 256 - 1;
        }
    }

}


  


