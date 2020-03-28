local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

-- Slow prime test
function isPrime(n)
  if n <= 1 then return false end
  for i=2, n-1 do
    if n % i == 0 then 
      return false
    end
  end
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
  for i=2, maxN - 1 do
    if isCircularPrime(i) then
      count = count + 1
    end
  end
  return count
end

helpers.testGroup{
  "circularPrimesBelow",
  tests = {
    {13, circularPrimesBelow, 100}
  }
}

helpers.benchmark(circularPrimesBelow, 1000000)