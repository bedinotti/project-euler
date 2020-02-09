local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

local BigInt = lib.BigInt
local testGroup = helpers.testGroup

-- Add division to BigInt
function BigInt.divide (lhs, rhs)
  return BigInt.new(1)
end
lib.bigint_mt.__div = BigInt.divide

-- Add printable display to BigInt
function BigInt.tostring (bigint)
  return bigint.value or "unknown"
end
lib.bigint_mt.__tostring = BigInt.tostring

function recurringLengthFor(denominator)
  local digits = ""
  local repeatCount = 0
  for powerOfTen = 1, math.huge do
    local nextDigit = ((10 ^ powerOfTen) / denominator) % 10
    if nextDigit == 0 then
      return #(shortestRepeatingString(digits) or "")
    end
    digits = digits .. string.format("%.f", nextDigit)
    repeatCount = #(shortestRepeatingString(digits) or "")
    if repeatCount > 0 then
      return repeatCount
    end
  end
  return 0
end

function shortestRepeatingString(inString)
  if #inString < 2 then
    return nil
  end
  for startIndex = 1, #inString do
    local midpoint = math.floor((startIndex + #inString) / 2)
    local stringToTest = string.sub(inString, startIndex, midpoint)
    if stringToTest == string.sub(inString, midpoint+1, #inString) then 
      -- try to find a smaller string
      return shortestRepeatingString(stringToTest) or stringToTest
    end
  end
  return nil
end

function longestRecurringDenominator(upTo)
  local longestRecurringLength = 0
  local longestDenominator = 0
  for d=2, upTo do
    local length = recurringLengthFor(d)
    if length > longestRecurringLength then
      longestRecurringLength = length
      longestDenominator = d
    end
  end
  return longestDenominator
end

testGroup {
  "BigInt division",
  tests = {
    {BigInt.new(1),            function (d) return BigInt.new(1) / d end, BigInt.new(1)},
    {BigInt.new("0.(3)"),      function (d) return BigInt.new(1) / d end, BigInt.new(3)},
    {BigInt.new("0.25"),       function (d) return BigInt.new(1) / d end, BigInt.new(4)},
    {BigInt.new("0.1(6)"),     function (d) return BigInt.new(1) / d end, BigInt.new(6)},
    {BigInt.new("0.(142857)"), function (d) return BigInt.new(1) / d end, BigInt.new(7)}
  }
}

testGroup {
  "shortestRepeatingString",
  skip = true,
  tests = {
    {nil, shortestRepeatingString, "5"},
    {"5", shortestRepeatingString, "55"},
    {"5", shortestRepeatingString, "555555"},
    {"3", shortestRepeatingString, "163333"},
    {"142857", shortestRepeatingString, "142857142857"},
    {"142857", shortestRepeatingString, "142857142857142857"},
  }
}

testGroup {
  "recurringLengthFor",
  skip = true,
  tests = {
    {0, recurringLengthFor, 2},
    {1, recurringLengthFor, 3},
    {1, recurringLengthFor, 6},
    {6, recurringLengthFor, 7},
    {0, recurringLengthFor, 10}
  }
}

testGroup {
  "longestRecurringDenominator",
  skip = true,
  tests = {
    {7, longestRecurringDenominator, 10},
  }
}

helpers.benchmark(longestRecurringDenominator, 1000)
-- wrong answers: 73