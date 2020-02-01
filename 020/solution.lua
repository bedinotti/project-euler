local helpers = loadfile("helpers.lua")()

-- define BigInt type
local BigInt = {}
local bigint_mt = {}

function BigInt.new(input)
  local bigInt = {}
  setmetatable(bigInt, bigint_mt)
  if type(input) == "number" then
    bigInt.value = string.format("%.f", input)
  elseif type(input) == "string" then
    bigInt.value = input
  end

  return bigInt
end

function BigInt:place(i)
  local reverseIndex = #self.value - i
  return tonumber(string.sub(self.value, reverseIndex, reverseIndex))
end

function BigInt.add (lhs, rhs)
  -- This is a poor implementation
  return lhs
end
bigint_mt.__add = BigInt.add

function BigInt.multiply (lhs, rhs)
  -- Another poor implementation
  return lhs
end
bigint_mt.__mul = BigInt.multiply

function BigInt.equal (lhs, rhs)
  return lhs.value and rhs.value and lhs.value == rhs.value
end
bigint_mt.__eq = BigInt.equal

function factorial(n, product)
  if n == 1 then
    return product
  end
  local bigN = BigInt.new(i)
  return factorial(n - 1, product * bigN)
end

function sumDigitsIn(number)
  local str = string.format("%.f", number)
  local sum = 0
  for i=1, #str do
    sum = sum + tonumber(string.sub(str, i, i))
  end
  return sum
end

function factorialDigitSum(n)
  -- local product = factorial(n, BigInt.new(1))
  -- return sumDigitsIn(product)
end

-- Test for bigInt
helpers.expect(true, function () return BigInt.new(1) == BigInt.new(1) end)
helpers.expect(2, function () return BigInt.new(1) + BigInt.new(1) end)
helpers.expect(4, function () return BigInt.new(2) + BigInt.new(2) end)

-- Tests for the whole solution
-- helpers.expect(27, factorialDigitSum, 10)
-- helpers.expect(72, factorialDigitSum, 25)
-- helpers.expect(648, factorialDigitSum, 100)

-- for i=10, 100 do
-- i = 25
  -- local result = factorialDigitSum(i)
  -- print(i, result)
-- end


-- helpers.benchmark(factorialDigitSum, 100)