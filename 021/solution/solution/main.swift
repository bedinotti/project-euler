//
//  main.swift
//  solution
//
//  Created by Chris Downie on 1/19/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Foundation

/// Measure how long it takes to execute the `method` closure
/// - Parameter method: The method to benchmark.
func benchmark(method: () -> Void) {
    let start = Date().timeIntervalSinceReferenceDate
    method()
    let end = Date().timeIntervalSinceReferenceDate
    print(String(format: "Solved in %.4fs", end - start))
}

func divisors(of number: Int) -> [Int] {
    return (1..<number / 2 + 1).filter { number % $0 == 0 }
}

func isAmicable(number: Int) -> Bool {
    let sumOfDivisors = divisors(of: number).reduce(0, +)
    let secondSum = divisors(of: sumOfDivisors).reduce(0, +)
    return secondSum == number && sumOfDivisors != secondSum
}

func uniqueAmicableSum(upTo limit: Int) -> Int {
    (1..<limit)
        .filter(isAmicable(number:))
        .reduce(0, +)
}

benchmark {
    print(uniqueAmicableSum(upTo: 10_000))
}
