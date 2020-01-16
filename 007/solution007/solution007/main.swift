//
//  main.swift
//  solution007
//
//  Created by Chris Downie on 1/15/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Foundation

func isPrime(number: Int) -> Bool {
    return (2..<number).first { number % $0 == 0 } == nil
}

func nthPrime(n: Int) -> Int {
    var remaining = n
    return (2..<Int.max).first { num -> Bool in
        if isPrime(number: num) {
            remaining -= 1
            if remaining == 0 {
                return true
            }
        }
        return false
    } ?? 0
}

print(nthPrime(n: 10_001))

