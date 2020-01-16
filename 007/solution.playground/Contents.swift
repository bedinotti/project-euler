import Cocoa

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

nthPrime(n: 10_001)
