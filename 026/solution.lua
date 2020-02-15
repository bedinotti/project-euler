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
  while not carriesSeen[carry] do -- carry ~= "0" and 
    carriesSeen[carry] = i
    -- loop until we have nothing to carry, or we've seen this carry before.
    local digit = numerator.value:sub(i, i)
    if digit == "" and decimalPlace == nil then
      decimalPlace = i
    end
    if digit == "" then
      digit = "0"
    end
    local numeratorDigit = tonumber(carry .. digit)
    local dividesEvenly = math.floor(numeratorDigit / denominator)
    local dividesRemainder = numeratorDigit % denominator

    carry = tostring(dividesRemainder) -- Is this only ever one digit?
    if decimalPlace == i then
      result = result .. "." .. dividesEvenly
    else 
      result = result .. dividesEvenly
    end
    i = i + 1
  end

  if carriesSeen[carry] then
    local startIndex = carriesSeen[carry]
    local beforeParen = result:sub(1, startIndex)
    local endParen = result:sub(startIndex + 1, -1)
    result = beforeParen .. "(" .. endParen .. ")"
  end

  -- Correct for (0) and 1.
  result = result:gsub("%(0%)", "")
  if result:sub(-1, -1) == "." then
    result = result:sub(1, -2)
  end

  return BigInt.new(result)
end

lib.bigint_mt.__div = BigInt.divide

-- Add printable display to BigInt
function BigInt.tostring (bigint)
  return bigint.value or "unknown"
end
lib.bigint_mt.__tostring = BigInt.tostring

function longestRecurringDenominator(upTo)
  local longestRecurringLength = 0
  local longestDenominator = 0
  for d=2, upTo do
    local result = BigInt.new(1) / BigInt.new(d)
    local repeatingBits = result.value:match("%((%d+)%)")
    repeatingBits = repeatingBits or ""

    local length = #repeatingBits
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
    {BigInt.new("0.5"),        function (d) return BigInt.new(1) / d end, BigInt.new(2)},
    {BigInt.new("0.(3)"),      function (d) return BigInt.new(1) / d end, BigInt.new(3)},
    {BigInt.new("0.25"),       function (d) return BigInt.new(1) / d end, BigInt.new(4)},
    {BigInt.new("0.1(6)"),     function (d) return BigInt.new(1) / d end, BigInt.new(6)},
    {BigInt.new("0.(142857)"), function (d) return BigInt.new(1) / d end, BigInt.new(7)}
  }
}

testGroup {
  "longestRecurringDenominator",
  tests = {
    {7, longestRecurringDenominator, 10},
  }
}

helpers.benchmark(longestRecurringDenominator, 1000)
-- wrong answers: 73, 219, 657, 803