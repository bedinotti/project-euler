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

func lengthOfRepeatingDecimal(for denominator: Int) -> Int {
    let decimal = repeatingDecimal(for: denominator)
    guard let openParenPosition = decimal.firstIndex(of: "("),
        let closeParenPosition = decimal.lastIndex(of: ")") else {
            return 0
    }
    return decimal[openParenPosition...closeParenPosition].count - 2
}

func repeatingDecimal(for denominator: Int) -> String {
    var carry = ""
    var carriesSeen = [String:Int]()
    var decimalPlace: Int?
    var result = ""

    var index = 0
    while carriesSeen[carry] == nil {
        carriesSeen[carry] = index
        
        let digit = index == 0 ? 1 : 0
        if index > 0 && decimalPlace == nil {
            decimalPlace = index
        }
        let numeratorDigit = Int("\(carry)\(digit)")!
        let dividesEvenly = numeratorDigit / denominator
        let dividesRemainder = numeratorDigit % denominator
        
        carry = "\(dividesRemainder)"
        if decimalPlace == index {
            result.append(".\(dividesEvenly)")
        } else {
            result.append("\(dividesEvenly)")
        }

        index += 1
    }
    
    let splitPoint = carriesSeen[carry]! + 1
    let splitIndex = result.index(result.startIndex, offsetBy: splitPoint)
    let beforeParen = result[result.startIndex..<splitIndex]
    let afterParen = result[splitIndex..<result.endIndex]
    result = "\(beforeParen)(\(afterParen))"
    result = result.replacingOccurrences(of: "(0)", with: "")
    return result
}

assert(lengthOfRepeatingDecimal(for: 2) == 0)
assert(lengthOfRepeatingDecimal(for: 3) == 1)
assert(lengthOfRepeatingDecimal(for: 6) == 1)
assert(lengthOfRepeatingDecimal(for: 7) == 6)
assert(lengthOfRepeatingDecimal(for: 10) == 0)

benchmark {
    (2..<1_000)
        .map { denominator -> (Int, Int) in
            (denominator, lengthOfRepeatingDecimal(for: denominator))
        }.reduce((-1, -1)) { (lastTuple, thisTuple) -> (Int, Int) in
            if lastTuple.1 > thisTuple.1 {
                return lastTuple
            }
            return thisTuple
        }.0
}
