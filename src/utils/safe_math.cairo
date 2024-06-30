#[starknet::library]


mod SafeMath {
    #[generate_trait]
    fn add(a: u256, b: u256) -> u256 {
        let c: u256 = a + b;
        assert(c >= a, 'SafeMath: addition overflow');
        c
    }

    #[generate_trait]
    fn sub(a: u256, b: u256) -> u256 {
        assert(a >= b, 'SafeMath: subtraction overflow');
        let c: u256 = a - b;
        c
    }

    #[generate_trait]
    fn mul(a: u256, b: u256) -> u256 {
        if a == 0 {
            0
        } else {
            let c: u256 = a * b;
            assert(c / a == b, 'SafeMath: mul overflow');
            c
        }
    }

    #[generate_trait]
    fn div(a: u256, b: u256) -> u256 {
        assert(b > 0, 'SafeMath: division by zero');
        let c: u256 = a / b;
        c
    }

    #[generate_trait]
    fn modulo(a: u256, b: u256) -> u256 {
        assert(b != 0, 'SafeMath: modulo by zero');
        let c: u256 = a % b;
        c
    }
}
