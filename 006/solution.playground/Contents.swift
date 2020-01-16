import Cocoa

func findDiff(until maxNum: Int) -> Int {
    let squaredSum = (1...maxNum)
        .map { pow(Double($0), 2) }
        .reduce(0, +)
    let sumSquared = pow(Double((1...maxNum).reduce(0, +)), 2)
    return Int(sumSquared - squaredSum)
}

findDiff(until: 100)
