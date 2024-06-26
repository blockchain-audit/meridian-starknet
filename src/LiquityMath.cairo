#[starknet::library]
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
      
      let prod_xy:u256 = x*y;//x.mul(y);
      let decProd:u256 = prod_xy+(DECIMAL_PRECISION/2)/DECIMAL_PRECISION;//.add(DECIMAL_PRECISION / 2).div(DECIMAL_PRECISION);
      decProd   
    }
    #[generate_trait]
    fn _decPow( base:u256, mut minutes:u256)->u256{

        if minutes > 525600000{

            minutes = 525600000;
        }            
        if minutes == 0
        {
            //DECIMAL_PRECISION
            let dec:u256=DECIMAL_PRECISION;  
            dec;
        }
        let mut y:u256 = DECIMAL_PRECISION;
        let mut x:u256 = base;
        let mut n:u256 = minutes;
        let mut i:u256=0;

        loop{   
            if n > 1 { 
               
                break ();
            }
            let n2:u256 = n % 2;
            if n == 0 {

                x = decMul(x,x);
                n = n/2;
               // n = n.div(2);
            } //else {

                 y = decMul(x,y);
                 x = decMul(x,x);
                 n = (n-1)/2;//(n.sub(1)).div(2);
           // }
        };        
        decMul(x,y)
    }
    #[generate_trait]
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


  


