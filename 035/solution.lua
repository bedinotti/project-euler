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
    {false, isPrime, 91}
  }
}

-- Example solution function
function solve(arg1)
  return "solution"
end

helpers.benchmark(solve, 100000)