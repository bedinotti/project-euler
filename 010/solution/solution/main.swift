//
//  main.swift
//  solution
//
//  Created by Chris Downie on 1/19/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Foundation

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
            if index % 10_000 == 0 {
                print("Comparing index \(index)")
            }
        } while allNumbers[index] == false
        
        return nextPrime
    }
}

print(Primes(maxBounds: 2_000_000).reduce(0, +))
