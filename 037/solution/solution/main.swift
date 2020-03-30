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


// Recylcing the prime sieve from problem 35
struct Primes: Sequence, IteratorProtocol {
    private let maxBounds: Int
    private var allNumbers: [Int: Bool]
    private var index: Int
    private var seenPrimes = Set<Int>()
    
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
        } while allNumbers[index] == false
        
        seenPrimes.insert(nextPrime)
        return nextPrime
    }
    
    func isPrime(_ n: Int) -> Bool {
        seenPrimes.contains(n)
    }
}

func isBidirectionalTruncatedPrime(_ n: Int, primes: Primes) -> Bool {
    guard n > 9 else {
        return false
    }
    
    // truncate right
    var str = String(n)
    while !str.isEmpty {
        if !primes.isPrime(Int(str)!) {
            return false
        }
        str = String(str.dropLast())
    }
    
    // truncate left
    str = String(n)
    while !str.isEmpty {
        if !primes.isPrime(Int(str)!) {
            return false
        }
        str = String(str.dropFirst())
    }
    return true
}

var testPrimes = Primes(maxBounds: 4000)
while testPrimes.next() != nil {}
assert(isBidirectionalTruncatedPrime(3797, primes: testPrimes))
assert(!isBidirectionalTruncatedPrime(19, primes: testPrimes))
assert(!isBidirectionalTruncatedPrime(3, primes: testPrimes))

func sumElevenBidirectionalTruncatedPrimes(maxGuess: Int = 1_000_000) -> Int {
    var sequence = Primes(maxBounds: maxGuess)
    while sequence.next() != nil {}
    var primes = [Int]()
    for prime in Primes(maxBounds: maxGuess) {
        if isBidirectionalTruncatedPrime(prime, primes: sequence) {
            primes.append(prime)
            
            if primes.count == 11 {
                return primes.reduce(0, +)
            }
        }
    }
    print("failed", primes)
    return -1
}

benchmark {
    sumElevenBidirectionalTruncatedPrimes()
}
