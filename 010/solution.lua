function primesLessThan(upperBound)
  return function () 
    local highestNumber = 2
    local foundPrimes = {}

    repeat
      if highestNumber % 10000 == 0 then
        print("Trying " .. highestNumber)
      end
      local isPrime = true

      -- Try to divide it by a previously known prime
      for _, divisor in ipairs(foundPrimes) do
        if highestNumber % divisor == 0 then
          isPrime = false
          break
        end
      end

      -- If it's still prime, then we're good.
      if isPrime then
        foundPrimes[#foundPrimes + 1] = highestNumber
        coroutine.yield(highestNumber)
      end

      highestNumber = highestNumber + 1
    until highestNumber > upperBound
  end
end

function primesIterator(upperBound)
  return coroutine.wrap(primesLessThan(upperBound))
end

local sum = 0
for prime in primesIterator(2000000) do
  sum = sum + prime
end
print(sum)
