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

enum Month: CaseIterable {
    case january, february, march, april, may, june, july, august, september, october, november, december

    func daysFor(year: Int) -> Int {
        let days: Int
        switch self {
        case .february where (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0):
            days = 29
        case .february:
            days = 28
        case .september, .april, .june, .november:
            days = 30
        default:
            days = 31
        }
        return days
    }
}

func solve() -> Int {
    let years = 1901...2000
    var daysSoFar = 0
    var firstSundays = 0
    years.forEach { year in
        Month.allCases.forEach { month in
            if daysSoFar % 7 == 0 {
                firstSundays += 1
            }
            daysSoFar += month.daysFor(year: year)
        }
    }
    return firstSundays
}

benchmark {
    print(solve())
}
