function primesLessThan(upperBound)
  return function () 
    local highestNumber = 2
    local foundPrimes = {}

    repeat
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
  local co = coroutine.create(primesLessThan(upperBound))
  return function() 
    local code, res = coroutine.resume(co)
    return res
  end
end

local sum = 0
for prime in primesIterator(10) do
  sum = sum + prime
end
print(sum)
