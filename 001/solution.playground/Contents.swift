import Cocoa

func compute() -> Int {
    return (0..<1000)
        .filter { ($0 % 5 == 0) || ($0 % 3 == 0) }
        .reduce(0, +)
}

print(compute())
