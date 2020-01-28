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

func parse(input: String) -> [[Int]] {
    input.components(separatedBy: "\n").map { line -> [Int] in
        line.components(separatedBy: " ").map { Int($0) ?? 0 }
    }
}

func solve(input: String) -> Int {
    let grid = parse(input: input)
    return grid.reversed().reduce([Int]()) { (bottomSums, thisRow) -> [Int] in
        guard !bottomSums.isEmpty else {
            return thisRow
        }
        return thisRow.enumerated().map { offset, value -> Int in
            value + max(bottomSums[offset], bottomSums[offset+1])
        }
    }.first!
}

let easyInput = """
3
7 4
2 4 6
8 5 9 3
"""

let challengeInput = """
75
95 64
17 47 82
18 35 87 10
20 04 82 47 65
19 01 23 75 03 34
88 02 77 73 07 63 67
99 65 04 28 06 16 70 92
41 41 26 56 83 40 80 70 33
41 48 72 33 47 32 37 16 94 29
53 71 44 65 25 43 91 52 97 51 14
70 11 33 28 77 73 17 78 39 68 17 57
91 71 52 38 17 14 91 43 58 50 27 29 48
63 66 04 68 89 53 67 30 73 16 69 87 40 31
04 62 98 27 23 09 70 98 73 93 38 53 60 04 23
"""

assert(solve(input: easyInput) == 23)

benchmark {
    print(solve(input: challengeInput))
}
