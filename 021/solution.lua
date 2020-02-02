local helpers = loadfile("helpers.lua")()

-- More metatable fun to make the tests more readable
-- By default, tables are tested by pointer-equality. This makes them test by value equality.
local array_mt = {}

function array(input) 
  setmetatable(input, array_mt)
  return input
end

array_mt.__eq = function (lhs, rhs)
  if #lhs ~= #rhs then
    return false
  end

  for i=1, #lhs do
    if lhs[i] ~= rhs[i] then
      return false
    end
  end
  return true
end

-- Use slow O(n) approach from my memory
function divisors(number)
  local result = array{}

  for i=1, number - 1 do
    if number % i == 0 then
      result[#result + 1] = i
    end
  end
  return result
end

-- Return two numbers if this number results in an amicable pair
function amicablePair(n)
  local firstDivisors = divisors(n)
  local a = 0
  for i=1, #firstDivisors do
    a = a + firstDivisors[i]
  end
  local secondDivisors = divisors(a)
  local b = 0
  for i=1, #secondDivisors do
    b = b + secondDivisors[i]
  end

  if b ~= n then
    return nil
  end

  if a ~= 0 and b ~= 0 and a ~= b then
    if a > b then
      return a, b
    else
      return b, a
    end
  end
end

-- Loop and solve
function uniqueAmicableSum(upTo)
  local amicableNumbers = {}
  for i=1, upTo - 1 do
    if not amicableNumbers[i] then
      local a, b = amicablePair(i)

      if a and a < upTo then
        amicableNumbers[a] = true
      end
      if b and b < upTo then
        amicableNumbers[b] = true
      end
    end
  end

  local sum = 0
  for num, _ in pairs(amicableNumbers) do
    sum = sum + num
  end
  return sum
end

print("\nTesting array value equality")
helpers.expect(true, function() return array{1, 2} == array{1, 2} end)

print("\nTesting divisor calculation")
helpers.expect(array{1, 2, 4, 5, 10, 11, 20, 22, 44, 55, 110}, divisors, 220)
helpers.expect(array{1, 2, 4, 71, 142}, divisors, 284)

print("\nTesting known amicable pairs")
function packAmicablePair(x) return array(table.pack(amicablePair(x))) end
helpers.expect(array{}, packAmicablePair, 1)
helpers.expect(array{284, 220}, packAmicablePair, 220)
helpers.expect(array{}, packAmicablePair, 1913)

print("\nUnique amicable sum of all amicable numbers < 10000")
helpers.benchmark(uniqueAmicableSum, 10000)
