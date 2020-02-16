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

func isPrime(_ n: Int) -> Bool {
    if n == 1 {
        return false
    }
    if n == 2 {
        return true
    }
    for i in 2..<max(n / 2 + 1, 2)  {
        if n % i == 0 {
            return false
        }
    }
    return true
}

func formulaFor(a: Int, b: Int) -> (Int) -> Int {
    { n in
        (n * n) + (a * n) + b
    }
}

func primeCount(a: Int, b: Int) -> Int {
    let quadatricFormula = formulaFor(a: a, b: b)
    
    let firstNonPrimeN = (0...).first { n -> Bool in
         !isPrime(quadatricFormula(n))
    }
    return (firstNonPrimeN ?? 0)
}

assert(primeCount(a: 1, b: 41) == 40)
assert(primeCount(a: -79, b: 1601) == 80)

func coefficientsWithMostConsecutivePrimes(aMaxExclusive: Int, bMaxInclusive: Int) -> (Int, Int) {
    var pairs = [(Int, Int)]()
    
    let aBound = aMaxExclusive > 0 ? aMaxExclusive - 1 : 0
    let aLowerBound = -aBound
    let bLowerBound = -bMaxInclusive
    
    (aLowerBound...aBound).forEach { aValue in
        (bLowerBound...bMaxInclusive).forEach { bValue in
            pairs.append((aValue, bValue))
        }
    }
    
    var bestPair: (Int, Int)?
    var primeCountForBestPair = 0
    pairs.forEach { pair in
        let count = primeCount(a: pair.0, b: pair.1)
        if count > primeCountForBestPair {
            bestPair = pair
            primeCountForBestPair = count
        }
    }
    
    return bestPair!
}

benchmark { () -> Int in
    let coefficientPair = coefficientsWithMostConsecutivePrimes(aMaxExclusive: 1000, bMaxInclusive: 1000)
    return coefficientPair.0 * coefficientPair.1
}
