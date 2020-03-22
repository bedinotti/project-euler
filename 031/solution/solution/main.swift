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

func permutationCount(from values: [Int], targetValue: Int) -> Int {
    guard targetValue != 0 || !values.isEmpty else {
        return 1
    }
    guard targetValue >= 0 else {
        return 0
    }
    
    var count = 0
    var remainingValues = values
    if let value = remainingValues.popLast() {
        let maxMultiple = Int(ceil(Double(targetValue) / Double(value)))
        count = (0...maxMultiple)
            .map { permutationCount(from: remainingValues, targetValue: targetValue - value * $0) }
            .reduce(0, +)
    }
    return count
}

assert(permutationCount(from: [50], targetValue: 50) == 1)
assert(permutationCount(from: [50, 25], targetValue: 50) == 2)
assert(permutationCount(from: [50, 25], targetValue: 100) == 3)

benchmark {
    permutationCount(from: [1, 2, 5, 10, 20, 50, 100, 200], targetValue: 200)
}
