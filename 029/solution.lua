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
  return product
end
lib.bigint_mt.__pow = BigInt.pow

helpers.testGroup {
  "BigInt multiplication",
  tests = {
    {BigInt.new(1),    function(a, b) return BigInt.new(a) ^ BigInt.new(b) end, 3, 0},
    {BigInt.new(3),    function(a, b) return BigInt.new(a) ^ BigInt.new(b) end, 3, 1},
    {BigInt.new(3125), function(a, b) return BigInt.new(a) ^ BigInt.new(b) end, 5, 5},
    {BigInt.new(64),   function(a, b) return BigInt.new(a) ^ BigInt.new(b) end, 4, 3}
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

  local count = 0
  for k, _ in pairs(seenValues) do
    count = count + 1
  end
  return count
end

helpers.testGroup {
  "Small distinct powers",
  tests = {
    {15, distinctPowers, 5, 5}
  }
}

helpers.benchmark(distinctPowers, 100, 100)