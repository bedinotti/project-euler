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

/// Represent unreduced fraction with two integers
struct Fraction {
    let numerator: Int
    let denominator: Int

    var value: Double { Double(numerator) / Double(denominator) }
}

extension Fraction: Equatable {
    static func == (lhs: Fraction, rhs: Fraction) -> Bool {
        lhs.value == rhs.value
    }
}

extension Fraction: Hashable {}


func digits(from int: Int) -> [Int] {
    String(format: "%d", int).map { Int(String($0))! }
}

func int(from digits: [Int]) -> Int {
    digits.reversed().enumerated().reduce(0) { (sum, tuple) -> Int in
        sum + Int(pow(10, Double(tuple.offset))) * tuple.element
    }
}

assert(digits(from: 102) == [1, 0, 2])
assert(int(from: [1, 0, 2]) == 102)

func isCurious(fraction: Fraction) -> Bool {
    guard fraction.numerator >= 10,
        fraction.numerator <= 99,
        fraction.denominator >= 10,
        fraction.denominator <= 99,
        fraction.numerator < fraction.denominator
        else {
        return false
    }

    // triviality check
    guard fraction.numerator % 10 != 0 && fraction.denominator % 10 != 0 else {
        return false
    }
    
    let numeratorDigits = digits(from: fraction.numerator)
    var denominatorDigits = digits(from: fraction.denominator)

    var hasCommonDigit = false
    var remainingNumeratorDigits = [Int]()
    numeratorDigits.forEach { digit in
        if let index = denominatorDigits.firstIndex(of: digit) {
            denominatorDigits.remove(at: index)
            hasCommonDigit = true
        } else {
            remainingNumeratorDigits.append(digit)
        }
    }
    
    if !hasCommonDigit || remainingNumeratorDigits.isEmpty || denominatorDigits.isEmpty {
        return false
    }
    let reducedFraction = Fraction(numerator: int(from: remainingNumeratorDigits), denominator: int(from: denominatorDigits))
    
    return reducedFraction == fraction
}

assert(isCurious(fraction: Fraction(numerator: 49, denominator: 98)))
assert(!isCurious(fraction: Fraction(numerator: 30, denominator: 50)))
assert(!isCurious(fraction: Fraction(numerator: 12, denominator: 34)))
assert(!isCurious(fraction: Fraction(numerator: 12, denominator: 21)))
assert(!isCurious(fraction: Fraction(numerator: 9, denominator: 98)))

func solve() -> Int {
    var curiousFractions = [Fraction]()
    
    (10...98).forEach { numerator in
        (numerator+1...99).forEach { denominator in
            let fraction = Fraction(numerator: numerator, denominator: denominator)
            if isCurious(fraction: fraction) {
                curiousFractions.append(fraction)
            }
        }
    }
    
    let fraction = curiousFractions.reduce(Fraction(numerator: 1, denominator: 1)) { accumulation, fraction in
        Fraction(numerator: accumulation.numerator * fraction.numerator,
                 denominator: accumulation.denominator * fraction.denominator)
    }
    
    var numerator = fraction.numerator
    var denominator = fraction.denominator
    var test = 2
    while test <= numerator {
        while numerator % test == 0 && denominator % test == 0 {
            numerator /= test
            denominator /= test
        }
        test += 1
    }
    return denominator
}

benchmark {
    solve()
}
