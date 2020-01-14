import Cocoa

func primeFactors(of number: Int) -> [Int: Int] {
    var factors = [Int: Int]()
    var number = number
    for i in 2...number {
        var power = 0
        if number % i == 0 {
            while number % i == 0 {
                number /= i
                power += 1
            }
        }
        if power > 0 {
            factors[i] = power
        }
    }
    return factors
}

func fastSmallestMultiple(upTo max: Int) -> Int {
    var allFactors = [Int: Int]()
    for i in 2...max {
        let factors = primeFactors(of: i)
        for (key, value) in factors {
            let existingPower = allFactors[key] ?? 0
            allFactors[key] = (value > existingPower) ? value : existingPower
        }
    }
    
    let product: Double = allFactors.reduce(1) { (product, factorPower) -> Double in
        product * pow(Double(factorPower.key), Double(factorPower.value))
    }
    return Int(product)
}


print(fastSmallestMultiple(upTo: 20))
