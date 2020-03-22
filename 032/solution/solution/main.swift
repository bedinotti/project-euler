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

func isPandigitalProduct(x: Int, y: Int) -> Bool {
    let product = x * y
    let allDigitsString = String(format: "%d%d%d", x, y, product)
    let digits = allDigitsString.map { Int(String($0))! }.sorted()

    return digits == [1, 2, 3, 4, 5, 6, 7, 8, 9]
}

assert(isPandigitalProduct(x: 39, y: 186))
assert(!isPandigitalProduct(x: 78, y: 93))

func sumAllPandigitalProducts() -> Int {
    let guessedMax = 9876 / 2
    
    var products = Set<Int>()
    var seenXValues = Set<Int>()
    (1...guessedMax).forEach { x in
        seenXValues.insert(x)
        (1...guessedMax).forEach { y in
            if !seenXValues.contains(y)
                && isPandigitalProduct(x: x, y: y) {
                products.insert(x * y)
            }
        }
    }
    
    return products.reduce(0, +)
}

benchmark {
    sumAllPandigitalProducts()
}
