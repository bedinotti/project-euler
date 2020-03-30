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
x

func circularPrimeCount(upperBound: Int) -> Int {
    let primes = Set<Int>(Primes(maxBounds: upperBound))
    
    return Primes(maxBounds: upperBound)
        .filter { prime in
            var string = String(prime)
            var isCircularPrime = true
            (1..<string.count).forEach { _ in
                string = String(string.last!).appending(string.dropLast(1))
                
                let number = Int(string)!
                if !primes.contains(number) {
                    isCircularPrime = false
                }
            }
            return isCircularPrime
        }.count
}

assert(circularPrimeCount(upperBound: 10) == 4)
assert(circularPrimeCount(upperBound: 100) == 13)

benchmark {
    circularPrimeCount(upperBound: 1_000_000)
}
