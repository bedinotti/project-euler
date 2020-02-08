local helpers = loadfile("helpers.lua")()

-- Reusing BigInt from #20

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

function BigInt.equal (lhs, rhs)
  return lhs.value and rhs.value and lhs.value == rhs.value
end
bigint_mt.__eq = BigInt.equal

-- Solving the fibonacci problem
function fibonacciIndexOfLength(length)
  local first = BigInt.new(1)
  local second = BigInt.new(1)

  for i=3, math.huge do
    local newTerm = first + second
    if #newTerm.value >= length then
      return i
    end
    first = second
    second = newTerm
  end
end

-- helpers.expect(12, fibonacciIndexOfLength, 3)
helpers.benchmark(fibonacciIndexOfLength, 1000)