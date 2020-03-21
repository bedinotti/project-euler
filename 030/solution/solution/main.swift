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

func sumOf(digits: [Int], raisedTo power: Int) -> Int {
    Int(digits.map { pow(Double($0), Double(power)) }.reduce(0, +))
}

func isSumOfPowers(digits: [Int], power: Int) -> Bool {
    let sum = sumOf(digits: digits, raisedTo: power)
    let sumString = String(format: "%d", sum)
    let sumDigits = sumString.map { Int(String($0))! }
    return sumDigits.sorted() == digits.sorted()
}

assert(isSumOfPowers(digits: [1, 6, 3, 4], power: 4))
assert(isSumOfPowers(digits: [1, 3, 4, 6], power: 4))
assert(isSumOfPowers(digits: [8, 2, 0, 8], power: 4))
assert(isSumOfPowers(digits: [9, 4, 4, 7], power: 4))
assert(!isSumOfPowers(digits: [1, 2, 3, 4], power: 4))
assert(!isSumOfPowers(digits: [1, 0, 0, 0], power: 4))

func findMaxDigits(for power: Int) -> Int {
    (1..<Int.max).first { maxDigits in
        let sum = Double(maxDigits) * pow(9, Double(power))
        let str = String(format: "%.f", sum)
        return str.count <= maxDigits
    }!
}

func nextDigits(for digits: [Int]) -> [Int] {
    guard digits != Array(repeating: 9, count: digits.count) else {
        return digits
    }
    guard let indexToIncrement = digits.lastIndex(where: { $0 < 9 }) else {
        return digits
    }
    let newValue = digits[indexToIncrement] + 1
    var newArray = [Int]()
    if indexToIncrement != digits.startIndex {
        newArray.append(contentsOf: digits[digits.startIndex..<indexToIncrement])
    }
    let updateCount = digits.distance(from: indexToIncrement, to: digits.endIndex)
    newArray.append(contentsOf: Array(repeating: newValue, count: updateCount))
    return newArray
}

func solve(power: Int) -> Int {
    var sum = 0
    for digitCount in (2...findMaxDigits(for: power)) {
        var digits = Array(repeating: 0, count: digitCount)
        let endState = Array(repeating: 9, count: digitCount)
        while digits != endState {
            if isSumOfPowers(digits: digits, power: power) {
                sum += sumOf(digits: digits, raisedTo: power)
            }
            
            digits = nextDigits(for: digits)
        }
    }
    return sum
}

benchmark {
    solve(power: 5)
}
