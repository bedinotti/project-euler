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
    print(String(format: "Solved in %.2fs", end - start))
}

func divisorCount(of n: Int) -> Int {
    guard n != 1 else {
        return 1
    }
    var i = 2
    var remainder = n
    var count = 1
    while i < n && remainder > 1 {
        defer {
            i += 1
        }
        guard remainder % i == 0 else {
            continue
        }

        var exponent = 0
        while remainder % i == 0 {
            exponent += 1
            remainder /= i
        }
        count *= (exponent + 1)
    }
    return count
}

func divisibleTriangle(minDivisors: Int) -> Int {
    var triangleNum = 1
    var i = 1
    while divisorCount(of: triangleNum) < minDivisors {
        i += 1
        triangleNum += i
    }
    return triangleNum
}

benchmark {
    let result = divisibleTriangle(minDivisors: 500)
    print(result)
}
