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

func digitSumFor(twoToThePowerOf n: Int) -> Int {
    let number = pow(2.0, Double(n))
    let string = String(format: "%.f", number)
    return string.map { Int(String($0)) ?? 0 }.reduce(0, +)
}

benchmark {
    print(digitSumFor(twoToThePowerOf: 1_000))
}
