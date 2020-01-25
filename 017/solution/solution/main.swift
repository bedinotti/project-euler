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

// Solution start
let numberWords = [
    1: "one",
    2: "two",
    3: "three",
    4: "four",
    5: "five",
    6: "six",
    7: "seven",
    8: "eight",
    9: "nine",
    10: "ten",
    11: "eleven",
    12: "twelve",
    13: "thirteen",
    14: "fourteen",
    15: "fifteen",
    16: "sixteen",
    17: "seventeen",
    18: "eighteen",
    19: "nineteen",
    20: "twenty",
    30: "thirty",
    40: "forty",
    50: "fifty",
    60: "sixty",
    70: "seventy",
    80: "eighty",
    90: "ninety",
    100: "onehundred",
    1000 : "onethousand",
]

func lettersIn(number: Int) -> Int {
    if let word = numberWords[number] {
        return word.count
    }
    var sum = 0
    
    if number < 100 {
        sum += lettersIn(number: (number / 10) * 10)
        if number % 10 != 0 {
            sum += lettersIn(number: number % 10)
        }
    } else if number < 1000 {
        sum += lettersIn(number: number / 100) + "hundred".count
        if number % 100 != 0 {
            sum += "and".count + lettersIn(number: number % 100)
        }
    }
    return sum
}

func addLettersTo(upperLimit: Int) -> Int {
    return (1...upperLimit).map(lettersIn(number:)).reduce(0, +)
}

// Tests
assert(lettersIn(number: 3) == "three".count)
assert(lettersIn(number: 99) == "ninetynine".count)
assert(lettersIn(number: 100) == "onehundred".count)
assert(lettersIn(number: 200) == "twohundred".count)
assert(lettersIn(number: 342) == "threehundredandfortytwo".count)
assert(lettersIn(number: 115) == "onehundredandfifteen".count)
assert(lettersIn(number: 1000) == "onethousand".count)

// benchmark run
benchmark {
    print(addLettersTo(upperLimit: 1000))
}
