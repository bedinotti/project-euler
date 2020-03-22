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


-- Example solution function
function sumAllPandigitalProducts()
  local availableDigits = {1, 2, 3, 4, 5, 6, 7, 8, 9}

  -- choose X, choose Y

  -- multiply, test result

  -- add product to a table as a key

  -- count keys

  return 0
end

helpers.benchmark(sumAllPandigitalProducts)