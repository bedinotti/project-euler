local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()


function isSumOfPowers(digitArray, power)
  local sum = 0
  for i=1, #digitArray do
    sum = sum + digitArray[i] ^ power
  end
  local sumString = string.format("%.f", sum)
  local sumDigits = {}
  for i=1, #sumString do
    local digit = tonumber(string.sub(sumString, i, i))
    sumDigits[i] = digit
  end
  table.sort(sumDigits)
  table.sort(digitArray)

  if #sumDigits ~= #digitArray then
    return false
  end

  for i=1, #sumDigits do
    if sumDigits[i] ~= digitArray[i] then
      return false
    end
  end
  
  return true
end

helpers.testGroup {
  "isSumOfPowers",
  tests = {
    {true, isSumOfPowers, {1, 6, 3, 4}, 4},
    {true, isSumOfPowers, {1, 3, 4, 6}, 4},
    {true, isSumOfPowers, {8, 2, 0, 8}, 4},
    {true, isSumOfPowers, {9, 4, 7, 4}, 4},
    {false, isSumOfPowers, {1, 2, 3, 4}, 4},
  }
}

function findMaxDigits(power) 
  -- figure this out.
  return 4
end

-- Solve it.
function digitPowerSum(power)
  local maxDigits = findMaxDigits(power)

  local sum = 0

  local digits = {0, 0}
  while #digits <= maxDigits do

    -- Reset to an aray of 1s, one larger than before. 
    for i=1, #digits do
      digits[i] = 1
    end
    digits[#digits+1] = 1
  end

  return sum
end

helpers.testGroup {
  "digitPowerSum",
  tests = {
    {19316, digitPowerSum, 4}
  }
}

-- helpers.benchmark(digitPowerSum, 4)