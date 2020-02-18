local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

local BigInt = lib.BigInt

function BigInt.add (lhs, rhs)
  local carry = 0
  local sum = ""
  for i=1, math.max(#lhs.value, #rhs.value) do
    local digit = lhs:place(i) + rhs:place(i) + carry
    -- print(string.format("%d * %d(%d)+ %d is %d", lhs:place(i), rhs:place(i), i, carry, digit))
    carry = math.floor(digit / 10)
    sum = string.format("%d", digit % 10) .. sum
    -- print(string.format("carry=%d, sum=%d", carry, sum))
  end
  if carry > 0 then
    sum = string.format("%d", carry) .. sum
  end
  return BigInt.new(sum)
end
lib.bigint_mt.__add = BigInt.add

-- Let's do a slower multiply because whyyyy
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

  -- print(string.format("Multiplying %s by %s", shorterNumber.value, longerNumber.value))
  for i=1, #shorterNumber.value do
    local carry = 0
    local term = ""
    for j=1, i-1 do term = term .. "0" end
    for j=1, #longerNumber.value do
      local digit = longerNumber:place(j) * shorterNumber:place(i) + carry
      -- print(string.format("%d * %d + %d is %d", longerNumber:place(j), shorterNumber:place(i), carry, digit))
      carry = math.floor(digit / 10)
      term = string.format("%d", digit % 10) .. term
      -- print(string.format("carry=%d, term = %d", carry, term))
    end

    if carry > 0 then
      term = string.format("%d", carry) .. term
      -- print("end of loop, term is now " .. term)
    end
    terms[#terms + 1] = BigInt.new(term)
  end

  local sum = BigInt.new(0)
  for i=1, #terms do
    sum = sum + terms[i]
  end

  return sum
end
lib.bigint_mt.__mul = BigInt.multiply

-- Let's add power to BigInt
function BigInt.pow (num, exp)
  local product = BigInt.new(1)
  -- this is a partial implementation, assuming the exp fits in the size of an int.
  for i=1, tonumber(exp.value) do
    product = product * num
    -- print(string.format("%s ^ %d is %s", num.value, i, product.value))
  end
  -- if #product.value > 200 then
  --   print(string.format("%s ^ %s thinks its %s", num.value, exp.value, product.value))
  -- end

  return product
end
lib.bigint_mt.__pow = BigInt.pow


helpers.testGroup {
  "BigInt addition",
  tests = {
    {BigInt.new("1333"), function (a, b) local x = BigInt.new(a) + BigInt.new(b); print(x.value); return x end, 1240, 93},
    {
      BigInt.new("2912125755884410842622249251854493"), 
      function (a, b) return BigInt.new(a) * BigInt.new(b) end, 
      "31313180170800116587336013460801",
      "93"
    }
  }
}

helpers.testGroup {
  "BigInt multiplication",
  -- skip = true,
  tests = {
    {BigInt.new("1333"), function (a, b) return BigInt.new(a) * BigInt.new(b) end, 43, 31},
    {
      BigInt.new("2912125755884410842622249251854493"), 
      function (a, b) return BigInt.new(a) * BigInt.new(b) end, 
      "31313180170800116587336013460801",
      "93"
    }
  }
}

helpers.testGroup {
  "BigInt exponentiation",
  -- skip = true,
  tests = {
    {BigInt.new(1),    function(a, b) return BigInt.new(a) ^ BigInt.new(b) end, 3, 0},
    {BigInt.new(3),    function(a, b) return BigInt.new(a) ^ BigInt.new(b) end, 3, 1},
    {BigInt.new(3125), function(a, b) return BigInt.new(a) ^ BigInt.new(b) end, 5, 5},
    {BigInt.new(64),   function(a, b) return BigInt.new(a) ^ BigInt.new(b) end, 4, 3},
    {
      BigInt.new("758249105831845933594546715344288617476769120250268508890936189254587920359456781681256381635348220868544500971808346750820604361621064506588359942316662865507114612000524007989494784832520237957"),
      function(a, b) return BigInt.new(a) ^ BigInt.new(b) end,
      93,
      99
    },
    {
      BigInt.new("70517166842361671824292844527018841425339528183274971326857065600676676593429480696356843492087384540774638590378176247826316205630758999112717474635449646492161658916048732743023014989424382130001"),
      function(a, b) return BigInt.new(a) ^ BigInt.new(b) end,
      93,
      100
    },
    {
      BigInt.new("100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
      function(a, b) return BigInt.new(a) ^ BigInt.new(b) end,
      100,
      100
    }
  }
}

function distinctPowers(maxA, maxB)
  local seenValues = {}
  for a=2, maxA do
    for b=2, maxB do
      local product = BigInt.new(a) ^ BigInt.new(b)
      seenValues[product.value] = true
    end

    if a % 10 == 0 then
      helpers.ping("a is up to " .. a)
    end
  end

  local keys = {}
  for k, _ in pairs(seenValues) do
    keys[#keys + 1] = k
  end
  table.sort(keys, function (a, b)
    if #a < #b then
      return true
    elseif #b < #a then
      return false
    else
      return a < b
    end
  end)
  -- print(table.unpack(keys))
  return #keys
end

helpers.testGroup {
  "Small distinct powers",
  -- skip = true,
  tests = {
    {15, distinctPowers, 5, 5}
  }
}

helpers.benchmark(distinctPowers, 100, 100)

-- fuzz test my multiplication
-- math.randomseed(os.time())
-- local mathIsPerfect = true
-- while mathIsPerfect do
--   local x = math.floor(math.random() * 51)
--   local y = math.floor(math.random() * 44)
--   local expected = string.format("%d", x * y)
--   local actual = BigInt.new(x) * BigInt.new(y)
--   if expected ~= actual.value then
--     print(string.format("%d * %d should be %s but it's %s", x, y, expected, actual.value))
--     mathIsPerfect = false
--   end
-- end