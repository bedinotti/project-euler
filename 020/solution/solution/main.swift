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

struct BigInt {
    let value: String
    var size: Int {
        value.count
    }

    subscript(index: Int) -> Int {
        // this is the reverse of the string. [0] is the ones digit, [1] is the tens digit, etc.
        // out of bounds access is always 0.
        guard index >= 0 else {
            return 0
        }
        guard index < value.count else {
            return 0
        }
        let vIndex = value.index(value.endIndex, offsetBy: -(index + 1))
        return Int(String(value[vIndex]))!
    }
    
    init(_ number: Int) {
        value = String(format: "%d", number)
    }

    init(_ string: String) {
        value = string.replacingOccurrences(of: "[^0-9]+", with: "", options: .regularExpression)
    }
    
    static func +(lhs: BigInt, rhs: BigInt) -> BigInt {
        var carry = 0
        var sum = ""
        for i in 0..<(max(lhs.size, rhs.size)) {
            let digit = lhs[i] + rhs[i] + carry
            if digit < 9 {
                carry = 0
                sum.append("\(digit)")
            } else {
                carry = digit / 10
                sum.append("\(digit % 10)")
            }
        }
        if carry > 0 {
            sum.append("\(carry)")
        }
        return BigInt(String(sum.reversed()))
    }
    
    static func *(lhs: BigInt, rhs: BigInt) -> BigInt {
        var terms = [BigInt]()
        let longerNumber = lhs.size > rhs.size ? lhs : rhs
        let smallerNumber = lhs.size > rhs.size ? rhs : lhs
        for i in 0..<smallerNumber.size  {
            var carry = 0
            var term = String(repeating: "0", count: i)
            for j in 0..<longerNumber.size {
                let digit = longerNumber[j] * smallerNumber[i] + carry
                if digit < 9 {
                    carry = 0
                    term.append("\(digit)")
                } else {
                    carry = digit / 10
                    term.append("\(digit % 10)")
                }
            }
            if carry > 0 {
                term.append("\(carry)")
            }
            terms.append(BigInt(String(term.reversed())))
        }
        
        return terms.reduce(BigInt(0), +)
    }
}

// This is the basic outline, and it would work if Int(or Double) was precise enough.
func factorial(n: Int) -> BigInt {
    (1...n).map { BigInt($0) }.reduce(BigInt(1), *)
}

func digitSum(number: BigInt) -> Int {
    number.value.compactMap { Int(String($0)) }.reduce(0, +)
}

func solve(n: Int) -> Int {
    let product = factorial(n: n)
    return digitSum(number: product)
}

benchmark {
    let result = solve(n: 100)
    print(result)
}
