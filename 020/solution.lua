local helpers = loadfile("helpers.lua")()

-- define BigInt type
local BigInt = {}
local bigint_mt = { __index = BigInt }

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
  local reverseIndex = #self.value - i + 1
  local result = tonumber(string.sub(self.value, reverseIndex, reverseIndex)) or 0
  return result
end

function BigInt.add (lhs, rhs)
  local carry = 0
  local sum = ""
  for i=1, math.max(#lhs.value, #rhs.value) do
    local digit = lhs:place(i) + rhs:place(i) + carry
    if digit < 9 then
      carry = 0
      sum = string.format("%d", digit) .. sum
    else
      carry = math.floor(digit / 10)
      sum = string.format("%d", digit % 10) .. sum
    end
  end
  if carry > 0 then
    sum = string.format("%d", carry) .. sum
  end
  return BigInt.new(sum)
end
bigint_mt.__add = BigInt.add

function BigInt.multiply (lhs, rhs)
  local terms = {}
  local longerNumber
  local shorterNumber
  if #lhs.value > #rhs.value then
    longerNumber = lhs
    shorterNumber = rhs
  else 
    longerNumber = rhs
    shorterNumber = lhs
  end

  for i=1, #shorterNumber.value do
    local carry = 0
    local term = ""
    for j=1, i-1 do term = term .. "0" end
    for j=1, #longerNumber.value do
      local digit = longerNumber:place(j) * shorterNumber:place(i) + carry

      if digit < 9 then
        carry = 0
        term = string.format("%d", digit) .. term
      else
        carry = math.floor(digit / 10)
        term = string.format("%d", digit % 10) .. term
      end
    end

    if carry > 0 then
      term = string.format("%d", carry) .. term
    end
    terms[#terms + 1] = BigInt.new(term)
  end

  local sum = BigInt.new(0)
  for i=1, #terms do
    sum = sum + terms[i]
  end

  return sum
end
bigint_mt.__mul = BigInt.multiply

function BigInt.equal (lhs, rhs)
  return lhs.value and rhs.value and lhs.value == rhs.value
end
bigint_mt.__eq = BigInt.equal

-- Begin the main problem solving, with Big Ints
function factorial(n, product)
  if n == 1 then
    return product
  end
  local bigN = BigInt.new(n)
  return factorial(n - 1, product * bigN)
end

function sumDigitsIn(number)
  local str = number.value
  local sum = 0
  for i=1, #str do
    sum = sum + tonumber(string.sub(str, i, i))
  end
  return sum
end

function factorialDigitSum(n)
  local product = factorial(n, BigInt.new(1))
  return sumDigitsIn(product)
end

print("Equality tests for BigInt")
helpers.expect(true, function () return BigInt.new(1) == BigInt.new(1) end)
helpers.expect(true, function () return BigInt.new(1) == BigInt.new("1") end)

print("\nPlace tests for BigInt")
helpers.expect(2, function () return BigInt.new(2):place(1) end)
helpers.expect(2, function () return BigInt.new(654321):place(2) end)
helpers.expect(6, function () return BigInt.new(654321):place(6) end)
helpers.expect(6, function () return BigInt.new("654321"):place(6) end)
helpers.expect(0, function () return BigInt.new(2):place(6) end)

print("\nAdd tests for BigInt")
helpers.expect(BigInt.new(2), function () return BigInt.new(1) + BigInt.new(1) end)
helpers.expect(BigInt.new(11), function () return BigInt.new(5) + BigInt.new(6) end)
helpers.expect(BigInt.new(2244), function () return BigInt.new(1010) + BigInt.new(1234) end)
helpers.expect(BigInt.new(4), function () return BigInt.new(2) + BigInt.new(2) end)

print("\nMultiply tests for BigInt")
helpers.expect(BigInt.new(2), function () return BigInt.new(1) * BigInt.new(2) end)
helpers.expect(BigInt.new(30), function () return BigInt.new(5) * BigInt.new(6) end)
helpers.expect(BigInt.new(603153), function () return BigInt.new(753) * BigInt.new(801) end)

print("\nTests for factorial digit sum solution")
helpers.expect(27, factorialDigitSum, 10)
helpers.expect(72, factorialDigitSum, 25)

print()
helpers.benchmark(factorialDigitSum, 100)