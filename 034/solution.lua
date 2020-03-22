local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

-- Factorial implementation with tail recursion
function factorial(n, product)
  product = product or 1
  if n < 1 then
    return 1
  elseif n == 1 then
    return product
  end

  return factorial(n - 1, product * n)
end

helpers.testGroup {
  "factorial",
  tests = {
    {1, factorial, 1},
    {24, factorial, 4},
    {120, factorial, 5},
  }
}

function isCurious(number)
  -- must have 2 digits to be curious
  if number < 10 then return false end

  local unusedDigits = number
  local sum = 0

  while unusedDigits > 0 do
    local digit = unusedDigits % 10
    sum = sum + factorial(digit)
    unusedDigits = math.floor(unusedDigits / 10)
  end

  return sum == number
end

helpers.testGroup {
  "isCurious",
  tests = {
    {true, isCurious, 145},
    {false, isCurious, 1},
    {false, isCurious, 2}
  }
}

-- helpers.benchmark(solve, 100000)