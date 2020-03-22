local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

function isPandigitalProduct(x, y)
  local product = x * y
  local allDigits = string.format("%d%d%d", x, y, product)

  local digitTable = {}
  for i=1, #allDigits do
    digitTable[i] = string.sub(allDigits, i, i)
  end
  table.sort(digitTable)

  local orderedString = table.concat(digitTable)
  return orderedString == "123456789"
end

helpers.testGroup {
  "isPandigitalProduct",
  tests = {
    {true, isPandigitalProduct, 39, 186},
    -- same product, but different digits
    {false, isPandigitalProduct, 78, 93},
  }
}

function multiplicands()
  -- This is the source of the time complexity of this problem. If I were more clever about
  -- how to choose numbers so they didn't share digits, then this would run way faster.

  -- 2 is the smallest multiplier that gives us the right digits 4 digits + 1 digit + 4 digits = 9 digits total.
  local guessedMax = 9876 / 2

  -- cache x's so we can avoid yielding x,y as y,x later
  local previousXs = {}

  return coroutine.wrap(function ()
    for x=1, guessedMax do
      previousXs[x] = true
      for y=1, guessedMax do
        if not previousXs[y] then
          coroutine.yield(x, y)
        end
      end
    end
  end)
end

-- Example solution function
function sumAllPandigitalProducts()
  local products = {}
  -- choose X, choose Y
  for x, y in multiplicands() do
    if isPandigitalProduct(x, y) then
      print(x .. "*" .. y .. " is pandigital!")
      products[x * y] = true
    end
  end

  -- count keys
  local sum = 0
  for key, _ in pairs(products) do
    sum = sum + key
  end

  return sum
end

helpers.benchmark(sumAllPandigitalProducts)