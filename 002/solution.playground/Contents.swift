import Cocoa

var fib = [Int]()
var current = 1
var previous = 1

while current <= 4_000_000 {
    fib.append(current)
    let sum = current + previous
    previous = current
    current = sum
}

let result = fib.filter { $0 % 2 == 0 }.reduce(0, +)
print(result)

