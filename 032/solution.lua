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
  local guessedMax = 1000
  return coroutine.wrap(function () 
    for x=1, guessedMax do
      for y=1, guessedMax do
        coroutine.yield(x, y)
      end
    end
  end)
end

-- Example solution function
function sumAllPandigitalProducts()
  local availableDigits = {1, 2, 3, 4, 5, 6, 7, 8, 9}
  local guessedMax = 987654321

  local products = {}
  -- choose X, choose Y
  -- this is dumb and slow. But also boring. And easy to write
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