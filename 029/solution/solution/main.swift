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

// Recycling BigInt from problem 25:
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
    
    static func ^(lhs: BigInt, rhs: BigInt) -> BigInt {
        guard rhs != BigInt(0) else {
            return BigInt(1)
        }
        guard rhs != BigInt(1) else {
            return lhs
        }
//        x ^ y can be expressed as x ^ (2 ^ n + m)
        let exponent = Double(rhs.value)!
        let n = floor(log2(exponent))
        let m = exponent - pow(2, n)
        
        var product = lhs
        (0..<Int(n)).forEach { _ in
            product = product * product
        }
        (0..<Int(m)).forEach { _ in
            product = product * lhs
        }

        return product
    }
}

extension BigInt: Equatable {}
extension BigInt: Hashable {}

assert(BigInt(2) ^ BigInt(0) == BigInt(1))
assert(BigInt(2) ^ BigInt(1) == BigInt(2))
assert(BigInt(2) ^ BigInt(2) == BigInt(4))

func solve(maxA: Int, maxB: Int) -> Int {
    var answerSet = Set<BigInt>()
    
    (2...maxA).forEach { a in
        (2...maxB).forEach { b in
            let result = BigInt(a) ^ BigInt(b)
            answerSet.insert(result)
        }
    }

    return answerSet.count
}

assert(solve(maxA: 5, maxB: 5) == 15)

benchmark {
    solve(maxA: 100, maxB: 100)
}
