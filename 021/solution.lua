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


print("\nTesting array value equality")
helpers.expect(true, function() return array{1, 2} == array{1, 2} end)

print("\nTesting divisor calculation")
helpers.expect(array{1, 2, 4, 5, 10, 11, 20, 22, 44, 55, 110}, divisors, 220)
helpers.expect(array{1, 2, 4, 71, 142}, divisors, 284)

