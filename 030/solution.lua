local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

function productOf(digitArray, power)
  local sum = 0
  for i=1, #digitArray do
    sum = sum + digitArray[i] ^ power
  end
  return sum
end

function isSumOfPowers(digitArray, power)
  local sum = productOf(digitArray, power)
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
    {false, isSumOfPowers, {1, 0, 0, 0}, 4}
  }
}

function findMaxDigits(power)
  local maxDigits = 0
  local sum = 0
  repeat
    maxDigits = maxDigits + 1
    sum = maxDigits * (9 ^ power)
  until #string.format("%.f", sum) <= maxDigits
  return maxDigits
end

helpers.testGroup {
  "findMaxDigits",
  tests = {
    {1, findMaxDigits, 1},
    {5, findMaxDigits, 4}
  }
}

function printArray(array) 
  local str = ""
  for i=1, #array do
    str = str .. "," .. array[i]
  end
  print(str)
end

function digitIncrementSequence(initialTable)
  return coroutine.wrap(function ()
    while true do
      local lastSubNineIndex = #initialTable
      while initialTable[lastSubNineIndex] == 9 and lastSubNineIndex > 0 do
        lastSubNineIndex = lastSubNineIndex - 1
      end

      if lastSubNineIndex == 0 then
        coroutine.yield(nil)
        return
      end

      local newValue = initialTable[lastSubNineIndex] + 1
      while lastSubNineIndex <= #initialTable do
        initialTable[lastSubNineIndex] = newValue
        lastSubNineIndex = lastSubNineIndex + 1
      end
      coroutine.yield(initialTable)
    end
  end)
end

function digitSequence(power)
  return coroutine.wrap(function ()
    local maxDigits = findMaxDigits(power)
    local digits = {0, 0}
    while #digits <= maxDigits do
      coroutine.yield(digits)

      for incrementedDigits in digitIncrementSequence(digits) do
        coroutine.yield(incrementedDigits)
      end

      -- Reset to an aray of 1s, one larger than before. 
      for i=1, #digits do
        digits[i] = 0
      end
      digits[#digits+1] = 0
    end
  end)
end

-- Solve it.
function digitPowerSum(power)
  local sum = 0

  for digits in digitSequence(power) do
    if isSumOfPowers(digits, power) then
      local number = productOf(digits, power)
      sum = sum + number
    end
  end

  return sum
end

helpers.testGroup {
  "digitPowerSum",
  tests = {
    {19316, digitPowerSum, 4}
  }
}

helpers.benchmark(digitPowerSum, 5)