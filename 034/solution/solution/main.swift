//
//  main.swift
//  solution
//
//  Created by Chris Downie on 1/19/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Foundation

/// Measure how long it takes to execute the `method` closure
/// - Parameter method: The method to benchmark.
func benchmark<T>(method: () -> T) {
    let start = Date().timeIntervalSinceReferenceDate
    let result = method()
    let end = Date().timeIntervalSinceReferenceDate
    print(String(format: "Solved in %.4fs", end - start))
    print(result)
}

func factorial(_ n: Int) -> Int {
    guard n > 1 else {
        return 1
    }
    return (1...n).reduce(1, *)
}

assert(factorial(4) == 24)
assert(factorial(5) == 120)

func digits(fromInt int: Int) -> [Int] {
    var digitInt = int
    var digits = [Int]()
    while digitInt > 0 {
        let digit = digitInt % 10
        digitInt /= 10
        digits.insert(digit, at: digits.startIndex)
    }
    return digits
}

assert(digits(fromInt: 123) == [1, 2, 3])

func int(fromDigits digits: [Int]) -> Int {
    digits.reversed().enumerated()
        .map { Int(pow(10.0, Double($0.offset))) * $0.element }
        .reduce(0, +)
}

assert(int(fromDigits: [1, 2, 3]) == 123)

func isCurious(_ n: Int) -> Bool {
    let nDigits = digits(fromInt: n)
    return nDigits.count >= 2 && n == nDigits.map(factorial(_:)).reduce(0, +)
}

assert(isCurious(145))
assert(!isCurious(2))

func solve() -> Int {
    let maxDigitValue = factorial(9)
    var maxDigits = 1
    while digits(fromInt: maxDigitValue * maxDigits).count >= maxDigits {
        maxDigits += 1
    }
    
    let guessedMax = maxDigits * maxDigitValue
    
    return (10...guessedMax).filter(isCurious(_:)).reduce(0, +)
}

benchmark {
    solve()
}
