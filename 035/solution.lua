local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

is_prime = {}

-- Recycling primesLessThan from problem 12
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

-- Prime test by trial division, memoized
function isPrime(n)
  if is_prime[n] then return is_prime[n] end
  if n <= 1 then return false end
  for i=2, n-1 do
    if n % i == 0 then
      is_prime[n] = false
      return false
    end
  end
  is_prime[n] = true
  return true
end

helpers.testGroup {
  "isPrime",
  tests = {
    {true, isPrime, 2},
    {true, isPrime, 97},
    {true, isPrime, 19},
    {false, isPrime, 91}
  }
}

function isCircularPrime(n)
  if isPrime(n) then
    local nString = tostring(n)
    for remainingRotations = #nString - 1, 1, -1 do
      nString = string.sub(nString, #nString, #nString) .. string.sub(nString, 1, #nString - 1, #nString - 1)
      if not isPrime(tonumber(nString)) then
        return false
      end
    end
    return true
  else
    return false
  end
end

helpers.testGroup{
  "isCircularPrime",
  tests = {
    {true, isCircularPrime, 2},
    {true, isCircularPrime, 17},
    {false, isCircularPrime, 19}
  }
}

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

  for i=1, #allPrimes do
    local prime = allPrimes[i]
    -- print("Testing if " .. prime .. " is a circular prime")
    local nString = tostring(prime)
    for remainingRotations = #nString - 1, 1, -1 do
      nString = string.sub(nString, #nString, #nString) .. string.sub(nString, 1, #nString - 1, #nString - 1)
      if not primeHash[tonumber(nString)] then
        -- print(nString .. " is not prime")
        goto nextPrime
      end
    end

    -- print("found: " .. prime)
    circularPrimes[#circularPrimes + 1] = prime

    ::nextPrime::
    -- print("trying next prime..")
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