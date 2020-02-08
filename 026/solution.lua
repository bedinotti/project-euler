local helpers = loadfile("helpers.lua")()

-- Test a group of inputs & outputs. 
function testGroup(input)
  local title = input[1] or input.title or ""
  if input.skip then
    print(string.format("\nSkipping %s...", title))
    return
  else
    print(string.format("\nTesting %s...", title))
  end
  for i=1, #(input.tests or {}) do
    helpers.expect(table.unpack(input.tests[i]))
  end
end

function recurringLengthFor(denominator)
  local digits = ""
  local repeatCount = 0
  for powerOfTen = 1, 20 do
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
  "shortestRepeatingString",
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
  tests = {
    {7, longestRecurringDenominator, 10},
  }
}

helpers.benchmark(longestRecurringDenominator, 1000)