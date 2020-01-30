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
    print(String(format: "Solved in %.4fs", end - start))
}

func factorial(n: Int) -> Double {
    (1...n).map { Double($0) }.reduce(1, *)
}

func digitSum(number: Double) -> Int {
    String(format: "%.f", number).compactMap { Int(String($0)) }.reduce(0, +)
}

func solve(n: Int) -> Int {
    let product = factorial(n: n)
    return digitSum(number: product)
}

benchmark {
    print(solve(n: 100))
}
