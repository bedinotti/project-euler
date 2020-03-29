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

// Recylcing the prime sieve from problem 10
struct Primes: Sequence, IteratorProtocol {
    private let maxBounds: Int
    private var allNumbers: [Int: Bool]
    private var index: Int
    
    init(maxBounds: Int) {
        self.maxBounds = maxBounds
        var numbers = [Int: Bool]()
        (2..<maxBounds).forEach { number in
            numbers[number] = true
        }
        allNumbers = numbers
        index = 2
    }
    
    mutating func next() -> Int? {
        guard let isIndexPrime = allNumbers[index], isIndexPrime else {
            return nil
        }
        let nextPrime = index
        
        for multiple in stride(from: nextPrime * 2, to: maxBounds, by: nextPrime) {
            allNumbers[multiple] = false
        }
        
        repeat {
            index = index + 1
//            if index % 10_000 == 0 {
//                print("Comparing index \(index)")
//            }
        } while allNumbers[index] == false
        
        return nextPrime
    }
}

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
