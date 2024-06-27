#[starknet::library]
#[starknet::SafeMath]

use debug::PrintTrait;


mod LiquityMath {

    //use SafeMath
    const DECIMAL_PRECISION: u256 = 1000000000000000000;//1e18
    const NICR_PRECISION: u256 = 1000000000000000000;//1e20
    #[generate_trait] 
    fn main() {
        
    }
    #[generate_trait]
    fn _min(a: u256, b:u256) -> u256 {
        if a < b {a}
          
        else {b}          
    }
    #[generate_trait]
    fn _max(a: u256, b:u256) -> u256 {
        if a >= b {a}

        else {b}          
    }
    #[generate_trait]
    fn decMul(x: u256, y: u256)-> u256{
      
      let prod_xy:u256 = x*y; //SafeMath.mul(x,y); //x.mul(y);
      let decProd:u256 = prod_xy+(DECIMAL_PRECISION/2)/DECIMAL_PRECISION;//.add(DECIMAL_PRECISION / 2).div(DECIMAL_PRECISION);
      decProd   
    }
    #[generate_trait]
    fn _decPow( _base:u256, mut _minutes:u256)->u256{

        let MAX_MINUTES:u256 = 525600000;
        let mut result:u256 = DECIMAL_PRECISION;

        if _minutes == 0 { result } 
        else {  

            if _minutes > MAX_MINUTES { _minutes = MAX_MINUTES;}

            let mut base:u256 = _base;
            let mut exp:u256  = _minutes;

            loop {
                if exp <= 1 {

                    break();
                }
                if ( exp % 2 != 0){

                result = decMul(result , base);
                exp = exp - 1;
                }
                base = decMul(base, base);
                exp /= 2;
            
            };
            decMul(result, base)
        }

    }

   // #[generate_trait]
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
    #[generate_trait]
    fn _computeNominalCR(mut coll:u256, debt:u256) -> u256 {
        if debt > 0 {

             //coll = coll.mul(NICR_PRECISION).div(debt);
            coll = coll*NICR_PRECISION/debt;
            coll      
        }      
        else {
           
            let maxVal = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
            maxVal
            // 2 ** 256 - 1
        }
    }
    #[generate_trait]
    fn _computeCR(coll:u256, debt:u256, price:u256)-> u256 {
       
        if debt > 0 {
            let newCollRatio:u256 = coll*price/debt; //coll.mul(price).div(debt);        
            newCollRatio
        }      
        else {
            
            let maxVal = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
            maxVal
              // 2 ** 256 - 1
        }        
    }

}


  


