import Cocoa

func isPalindrome(_ number: Int) -> Bool {
    let string = "\(number)"
    let reversed = String(string.reversed())
    return string == reversed
}

var largestProduct = 1
for x in 100..<1000 {
    for y in 100..<1000 {
        let product = x * y
        if isPalindrome(product) && product > largestProduct {
            largestProduct = product
        }
    }
}

print(largestProduct)
