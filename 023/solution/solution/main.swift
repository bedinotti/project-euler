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
func benchmark<T>(method: () -> T) {
    let start = Date().timeIntervalSinceReferenceDate
    let result = method()
    let end = Date().timeIntervalSinceReferenceDate
    print(String(format: "Solved in %.4fs", end - start))
    print(result)
}

func divisors(number: Int) -> [Int] {
    if number == 1 || number == 2 {
        return [1]
    }
    return (1...number/2).filter { number % $0 == 0 }
}

func isAbundant(number: Int) -> Bool {
    divisors(number: number).reduce(0, +) > number
}

func sumOfNonAbundantSumPairs() -> Int {
    let pairsAreAbove = 28123
    var numbersToSum = Set((1...pairsAreAbove))
    
    let abundantNumbers = (1...pairsAreAbove).filter(isAbundant(number:))
    // Remove all numbers that are the sum of two abundant numbers.
    abundantNumbers.enumerated().forEach { offset, number in
        abundantNumbers[offset...].forEach { secondNumber in
            numbersToSum.remove(number + secondNumber)
        }
    }
    
    return numbersToSum.reduce(0, +)
}

assert(isAbundant(number: 28) == false)
assert(isAbundant(number: 12) == true)
assert(isAbundant(number: 11) == false)

benchmark {
    sumOfNonAbundantSumPairs()
}
