local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

local BigInt = lib.BigInt

-- Let's add power to BigInt
function BigInt.pow (num, exp)
  local product = BigInt.new(1)
  -- this is a partial implementation, assuming the exp fits in the size of an int.
  for i=1, tonumber(exp.value) do
    product = product * num
  end
  -- if #product.value > 200 then
  --   print(string.format("%s ^ %s thinks its %s", num.value, exp.value, product.value))
  -- end

  return product
end
lib.bigint_mt.__pow = BigInt.pow

helpers.testGroup {
  "BigInt multiplication",
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
  tests = {
    {15, distinctPowers, 5, 5}
  }
}

-- helpers.benchmark(distinctPowers, 100, 100)