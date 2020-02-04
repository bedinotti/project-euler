local helpers = loadfile("helpers.lua")()

-- Test a group of inputs & outputs. 
function testGroup(input)
  local title = string.format("\nTesting %s...", input.title or "")
  print(title)
  for i=1, #(input.tests or {}) do
    helpers.expect(table.unpack(input.tests[i]))
  end
end

-- Use slow O(n) approach from my memory
function divisorsFor(number)
  local result = {}

  for i=1, number/2 + 1 do
    if number % i == 0 then
      result[#result + 1] = i
    end
  end
  return result
end

-- Return true if a number is abundant
function isAbundant(number) 
  local divisors = divisorsFor(number)
  local sum = 0
  for i=1, #divisors do
    sum = sum + divisors[i]
  end
  return sum > number
end

-- return true if a number is the sum of two abundant numbers. 
function isSumOfTwoAbundantNumbers(number)
  for i=1, number / 2 + 1 do
    local biggerHalf = number - i
    if isAbundant(i) and isAbundant(biggerHalf) then
      return true
    end
  end
  return false
end

-- This is a terrible name, but suits the problem
function sumOfNotAbundantSumNumbers()
  local abundantSumsAreAllAtOrAbove = 28123
  local sum = 0
  for i=1, abundantSumsAreAllAtOrAbove - 1 do
    if not isSumOfTwoAbundantNumbers(i) then
      sum = sum + i
    end
  end
  return sum
end

testGroup{
  title = "isAbundant",
  tests = {
    {false, isAbundant, 28},
    {true, isAbundant, 12}
  }
}

-- helpers.expect(false, isAbundant, 28)
-- helpers.expect(true, isAbundant, 12)

-- helpers.benchmark(solve, 100000)