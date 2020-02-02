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

let capitalAOffset = 64
func computeScore(forName name: String, position: Int = 1) -> Int {
    name.uppercased()
        .unicodeScalars.map { Int($0.value) - capitalAOffset }
        .reduce(0, +) * position
}

assert(computeScore(forName: "COLIN") == 53)
assert(computeScore(forName: "COLIN", position: 938) == 49714)

benchmark {
    computeScore(forName: "COLIN")
}
