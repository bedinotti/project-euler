-- This file contains a library of previously-invented solutions that have turned out to be useful for other problems

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
  if i > #self.value or i < 0 then
    return 0
  end
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


-- Exports
return {
  BigInt    = BigInt,
  -- Export the metatables to make these types extendable
  bigint_mt = bigint_mt
}