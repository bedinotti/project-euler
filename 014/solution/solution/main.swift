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

func collatz(n: Int, length: Int = 0) -> Int {
    if n == 1 {
        return n + length
    }
    
    let out: Int
    if n % 2 == 0 {
        out = n / 2
    } else  {
        out = (3*n) + 1
    }
    return collatz(n: out, length: length + 1)
}

func solve() {
    let result = (1..<1_000_000)
        .map { ($0, collatz(n: $0)) }
        .reduce((0,0)) { (lastTuple, thisTuple) -> (Int, Int) in
            if lastTuple.1 > thisTuple.1 {
                return lastTuple
            }
            return thisTuple
        }
    let (number, length) = result
    print("\(number) produced a series of length \(length)")
}

benchmark {
    solve()
}
