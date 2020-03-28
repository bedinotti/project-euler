local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

-- Recycling prime sieve coroutine from problem 12
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

-- Example solution function
function circularPrimesBelow(maxN)
  local count = 0

  local allPrimes = {}
  local primeHash = {}
  local circularPrimes = {}

  -- Populate our list of all primes, and an O(n) hash for prime testing.
  for i in primesLessThan(maxN) do
    allPrimes[#allPrimes + 1] = i
    primeHash[i] = true
  end

  -- Filter the primes into our circularPrimes array
  for i=1, #allPrimes do
    local prime = allPrimes[i]
    local nString = tostring(prime)
    for remainingRotations = #nString - 1, 1, -1 do
      nString = string.sub(nString, #nString, #nString) .. string.sub(nString, 1, #nString - 1, #nString - 1)
      if not primeHash[tonumber(nString)] then
        goto nextPrime
      end
    end

    circularPrimes[#circularPrimes + 1] = prime

    ::nextPrime::
  end

  return #circularPrimes
end

helpers.testGroup{
  "circularPrimesBelow",
  tests = {
    {4, circularPrimesBelow, 10},
    {13, circularPrimesBelow, 100}
  }
}

helpers.benchmark(circularPrimesBelow, 1000000)