local helpers = loadfile("helpers.lua")()

-- Test a group of inputs & outputs. 
function testGroup(input)
  local title = string.format("\nTesting %s...", input.title or "")
  print(title)
  for i=1, #(input.tests or {}) do
    helpers.expect(table.unpack(input.tests[i]))
  end
end

-- Use slow O(n) approach from my memory, memoized
divisorsMemo = {}
function divisorsFor(number)
  if divisorsMemo[number] ~= nil then return divisorsMemo[number] end
  local result = {}
  for i=1, number/2 do
    if number % i == 0 then
      result[#result + 1] = i
    end
  end
  divisorsMemo[number] = result
  return result
end

-- Return true if a number is abundant, memoized
abundantMemo = {}
function isAbundant(number) 
  if abundantMemo[number] ~= nil then return abundantMemo[number] end
  local divisors = divisorsFor(number)
  -- print("divisors for " .. number, table.unpack(divisors))
  local sum = 0
  for i=1, #divisors do
    sum = sum + divisors[i]
  end
  local result = sum > number
  abundantMemo[number] = result
  return result
end

-- This is a terrible name, but suits the problem
function sumOfNotAbundantSumNumbers()
  local abundantSumsAreAllAtOrAbove = 28123

  local abundantList = {}
  for i=1, abundantSumsAreAllAtOrAbove do
    if isAbundant(i) then
      abundantList[#abundantList + 1] = i
    end
  end
  helpers.ping("Abundant list generated")

  local pairAbundantSet = summedPairsIn(abundantList)
  helpers.ping("Abundant pairwise sums generated")

  local sum = 0
  for i=1, abundantSumsAreAllAtOrAbove do
    if not pairAbundantSet[i] then
      sum = sum + i
    end
  end
  return sum
end

function summedPairsIn(pairList)
  local sums = {}
  for i=1, #pairList do
    for j=i, #pairList do
      sums[pairList[i] + pairList[j]] = true
    end
  end
  return sums
end

-- Begin tests
testGroup{
  title = "isAbundant",
  tests = {
    {false, isAbundant, 28},
    {true, isAbundant, 12},
    {false, isAbundant, 11},
  }
}
for i=1, 11 do
  helpers.expect(false, isAbundant, i)
end

--solve the problem
helpers.benchmark(sumOfNotAbundantSumNumbers)
