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

func isPalindrome(_ string: String) -> Bool {
    string == String(string.reversed())
}

let binaryHash: [Character: String] = [
    "0": "0000",
    "1": "0001",
    "2": "0010",
    "3": "0011",
    "4": "0100",
    "5": "0101",
    "6": "0110",
    "7": "0111",
    "8": "1000",
    "9": "1001",
    "A": "1010",
    "B": "1011",
    "C": "1100",
    "D": "1101",
    "E": "1110",
    "F": "1111",
]

func binaryString(from number: Int) -> String {
    let str = String(format: "%X", number).map { binaryHash[$0]! }.reduce("", +)
    if let firstOne = str.firstIndex(of: "1") {
        return String(str[firstOne...])
    }
    return str
}

assert(binaryString(from: 10) == "1010")
assert(binaryString(from: 17) == "10001")

func isDoublePalindrome(number: Int) -> Bool {
    isPalindrome(String(number)) && isPalindrome(binaryString(from: number))
}

func sumDoublePalindromesLessThan(_ maxBounds: Int) -> Int {
    (1..<maxBounds)
        .filter(isDoublePalindrome(number:))
        .reduce(0, +)
}

benchmark {
    sumDoublePalindromesLessThan(1_000_000)
}
