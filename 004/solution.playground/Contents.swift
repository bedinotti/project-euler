import Cocoa

func isPalindrome(_ number: Int) -> Bool {
    let string = "\(number)"
    let reversed = String(string.reversed())
    return string == reversed
}

var largestProduct = 1
for x in (100..<1000).reversed() {
    for y in (100..<1000).reversed() {
        let product = x * y
        // Let's do the largest check first, to avoid the space allocation of the reversed string
        // in isPalindrome.
        if product > largestProduct {
            if isPalindrome(product) {
                largestProduct = product
            }
        } else {
            // Since we're going high-to-low now, if we're not getting large products, they'll only
            // get smaller from here on out. Break out of the inner loop and try the next highest
            // number
            break
        }
    }
}

print(largestProduct)
