local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

-- Recycling prime sieve coroutine, with global prime hash
primes = {}
function primesLessThan(upperBound)
  return coroutine.wrap(function ()
    local allNumbers = {}
    for i = 1, upperBound - 1 do
      allNumbers[#allNumbers + 1] = i
    end
    local maxIndex = #allNumbers

    local index = 2
    repeat
      local nextPrime = allNumbers[index]
      primes[nextPrime] = true
      coroutine.yield(nextPrime)

      for multiples = 2 * nextPrime, maxIndex, nextPrime do
        allNumbers[multiples] = nil
      end

      repeat
        index = index + 1
      until allNumbers[index] ~= nil or index > maxIndex
    until index > maxIndex
  end)
end

-- relies on global state, primesLessThan(n) must have already been called for this to work
-- this assumes n is prime. 
function isBidirectionTruncablePrime(n)
  local numberStr = tostring(n)
  if #numberStr < 2 then return false end

  -- truncate left
  while #numberStr > 0 do
    if not primes[tonumber(numberStr)] then
      return false
    end
    numberStr = string.sub(numberStr, 2, #numberStr)
  end

  -- truncate right
  numberStr = tostring(n)
  while #numberStr > 0 do
    if not primes[tonumber(numberStr)] then
      return false
    end
    numberStr = string.sub(numberStr, 1, -2)
  end

  return true
end

-- prepare isBidirectionTruncablePrime for testing
for i in primesLessThan(4000) do end

helpers.testGroup{
  "isBidirectionTruncablePrime",
  tests = {
    {true, isBidirectionTruncablePrime, 3797},
    {false, isBidirectionTruncablePrime, 19},
    {false, isBidirectionTruncablePrime, 3}
  }
}

function findElevenTruncablePrimes(largeGuess)
  local found = {}
  for prime in primesLessThan(largeGuess) do
    if isBidirectionTruncablePrime(prime) then
      found[#found + 1] = prime
      -- Go until we find 11, then
      if #found == 11 then
        -- accumulate and return the sum.
        local sum = 0
        for i=1, #found do
          sum = sum + found[i]
        end
        return sum
      end
    end
  end

  print("Only found " .. #found .. ":" .. table.concat(found, ","))

  return #found
end

helpers.benchmark(findElevenTruncablePrimes, 1000000)