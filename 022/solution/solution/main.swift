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

// Take the file name in from the arguments list
guard let fileName = ProcessInfo.processInfo.arguments.dropFirst().first else {
    preconditionFailure("Usage: solution [filename]")
}

let capitalAOffset = 64
func computeScore(forName name: String, position: Int = 1) -> Int {
    name.uppercased()
        .unicodeScalars.map { Int($0.value) - capitalAOffset }
        .reduce(0, +) * position
}

assert(computeScore(forName: "COLIN") == 53)
assert(computeScore(forName: "COLIN", position: 938) == 49714)

func loadFile() -> [String] {
    guard let fileData = FileManager.default.contents(atPath: fileName) else {
        print("File is empty: \(fileName)")
        return []
    }
    guard let string = String(data: fileData, encoding: .utf8) else {
        print("File wasn't a text file: \(fileName)")
        return []
    }

    let regex = try! NSRegularExpression(pattern: #"(\w+)"#, options: [])
    return regex
        .matches(in: string, options: [], range: NSRange(string.startIndex..., in: string))
        .map { String(string[Range($0.range, in: string)!]) }
}

let names = loadFile()
print(names)

benchmark {
    computeScore(forName: "COLIN")
}
