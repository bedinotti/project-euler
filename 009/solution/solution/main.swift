//
//  main.swift
//  solution
//
//  Created by Chris Downie on 1/18/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Foundation

func isCorrectTriplet(a: Int, b: Int, c: Int) -> Bool {
    a < b
    && b < c
    && a + b + c == 1000
    && pow(Double(a), 2) + pow(Double(b), 2) == pow(Double(c), 2)
}

func solve() -> (Int, Int, Int)? {
    for a in 1...1000 {
        for b in (a+1)...1000 {
            let c = 1000 - (a + b)
            if isCorrectTriplet(a: a, b: b, c: c) {
                return (a, b, c)
            }
        }
    }
    return nil
}

if let x = solve() {
    print(x.0 * x.1 * x.2)
} else {
    print("not found")
}
