// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts for Cairo v0.14.0 (utils/math.cairo)

fn add(a: u256, b: u256 ) -> u256 {
    let c :u256 = a + b;
    assert(c >= a, 'SafeMath: addition overflow');
    c
}

fn sub(a: u256, b: u256 ) -> u256 {
    assert(a >= b, 'SafeMath: subtraction overflow');
    let c :u256 = a - b;
    c
}

fn mul(a: u256, b: u256) -> u256{
    if a == 0 {
        0
    }
    else {
    let c: u256 = a * b;
    assert(c / a == b, 'SafeMath: mul overflow');
    c
    }
}

fn div(a: u256, b: u256 ) -> u256 {
    assert(b > 0, 'SafeMath: division by zero');
    let c: u256 = a / b;
    c
}

fn modulo(a: u256, b: u256) -> u256 {
    assert(b != 0, 'SafeMath: modulo by zero');
    let c: u256 = a % b;
    c
}

#[test]
fn test(){
    // add(100, 10);
    // sub(100, 99);
    mul(100, 10);
    // div(100, 99);
    // modulo(100, 15);
}
// fn main() {
//     add(100, 10);
//     sub(100, 99);
//     mul(100, 999);
//     div(100, 99);
    // modulo(10, 5);
// }