import Cocoa

func primeFactors(of value: Int) -> [Int] {
    var divisor = 2
    var primes = [Int]()
    var number = value
    while number > 1 {
        if number % divisor == 0 {
            primes.append(divisor)
            while number % divisor == 0 {
                number /= divisor
            }
        }
        divisor += 1
    }
    return primes
}

// Again, test that the algorithm works
print(primeFactors(of: 13195))

// Now go for the big one
print(primeFactors(of: 600851475143))
