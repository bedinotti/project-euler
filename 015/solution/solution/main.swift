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

benchmark {
    let sideCount = 20
    var vertexPathCount = [1, 1]
    (3...(sideCount+1)).forEach { _ in
        var newPathCount = [1]
        (0..<(vertexPathCount.count-1)).forEach { index in
            newPathCount.append(vertexPathCount[index] + vertexPathCount[index + 1])
        }
        newPathCount.append(1)
        vertexPathCount = newPathCount
    }
    
    let result = vertexPathCount.reduce(0) { (result, newVertex) -> Int in
        result + newVertex * newVertex
    }
    print(result)
}
