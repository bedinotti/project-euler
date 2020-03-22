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

function allCuriousSum() 
  -- figure out an upper bound guess
  local digitMax = factorial(9)
  local guessedMax = 1000

  for i=1, math.huge do
    local value = i * digitMax
    local string = tostring(value)
    if #string <= i then
      guessedMax = value
      break
    end
  end
  print("guessed max:" .. guessedMax)

  local sum = 0
  for i=10, guessedMax do
    if isCurious(i) then
      print("Found curious number:" .. i)
      sum = sum + i
    end
  end

  return sum
end

helpers.benchmark(allCuriousSum)