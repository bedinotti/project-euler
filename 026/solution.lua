local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

local BigInt = lib.BigInt
local testGroup = helpers.testGroup

-- Add division to BigInt
function BigInt.divide (numerator, denominator)
  -- Assumptions: numerator & denominator are whole numbers. Denominator can fit into an int.
  local denominator = tonumber(denominator.value)
  local carry = ""
  local carriesSeen = {}
  local result = ""
  local decimalPlace = nil

  local i = 1
  while not carriesSeen[carry] and i < 10 do -- carry ~= "0" and 
    carriesSeen[carry] = i
    -- loop until we have nothing to carry, 
    local digit = numerator.value:sub(i, i)
    -- print("digit for ", numerator.value, digit)
    if digit == "" and decimalPlace == nil then
      -- print("setting decimal plae")
      decimalPlace = i
    end
    if digit == "" then
      digit = "0"
    end
    local numeratorDigit = tonumber(carry .. digit) -- "1"
    -- print("numeratorDigit", numeratorDigit)
    local dividesEvenly = math.floor(numeratorDigit / denominator)  -- 1 / 2 => 0
    local dividesRemainder = numeratorDigit % denominator -- 1 % 2 => 1

    carry = tostring(dividesRemainder) -- Is this only ever one digit?
      if decimalPlace == i then
        result = result .. "." .. dividesEvenly
      else 
        result = result .. dividesEvenly
      end
    -- print("Result is now " .. result)
    i = i + 1
  end

  -- todo: add the decimal point back in at `decimalPlace`
  -- print("missing decimal place at", decimalPlace)
  return BigInt.new(result:sub(1, -2))
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
    -- {BigInt.new(1),            function (d) return BigInt.new(1) / d end, BigInt.new(1)},
    {BigInt.new("0.5"),            function (d) return BigInt.new(1) / d end, BigInt.new(2)},
    -- {BigInt.new("0.(3)"),      function (d) return BigInt.new(1) / d end, BigInt.new(3)},
    {BigInt.new("0.25"),       function (d) return BigInt.new(1) / d end, BigInt.new(4)},
    -- {BigInt.new("0.1(6)"),     function (d) return BigInt.new(1) / d end, BigInt.new(6)},
    -- {BigInt.new("0.(142857)"), function (d) return BigInt.new(1) / d end, BigInt.new(7)}
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

-- helpers.benchmark(longestRecurringDenominator, 1000)
-- wrong answers: 73