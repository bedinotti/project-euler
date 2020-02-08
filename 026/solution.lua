local helpers = loadfile("helpers.lua")()

-- Test a group of inputs & outputs. 
function testGroup(input)
  local title = string.format("\nTesting %s...", input[1] or input.title or "")
  print(title)
  for i=1, #(input.tests or {}) do
    helpers.expect(table.unpack(input.tests[i]))
  end
end

function recurringLengthFor(denominator)
  local str = string.format("%.30f", 1.0/denominator)
  return 6
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

-- helpers.benchmark(solve, 100000)