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

func diagonalSum(sideLength: Int) -> Int {
    var lastSeenCell = 0
    var sum = 0
    
    for side in stride(from: 1, to: sideLength+1, by: 2) {
        if side == 1 {
            lastSeenCell = 1
            sum = sum + lastSeenCell
        } else {
            (0..<4).forEach { _ in
                lastSeenCell += side - 1
                sum += lastSeenCell
            }
        }
    }
    return sum
}

assert(diagonalSum(sideLength: 1) == 1)
assert(diagonalSum(sideLength: 3) == 25)
assert(diagonalSum(sideLength: 5) == 101)

benchmark {
    diagonalSum(sideLength: 1001)
}
