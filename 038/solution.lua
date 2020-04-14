local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

function pandigitalProduct(number, n) 
  local products = {}
  for mult=1, n do
    products[#products + 1] = string.format("%d", mult * number)
  end
  return table.concat(products)
end

-- Example solution function
function isPandigitalMultiple(number, n)
  local str = pandigitalProduct(number, n)
  local digits = {}
  for i=1, #str do
    digits[#digits + 1] = string.sub(str, i, i)
  end
  table.sort(digits)

  return table.concat(digits) == "123456789", str
end

helpers.testGroup{
  "isPandigitalMultiple",
  tests = {
    {true, isPandigitalMultiple, 192, 3},
    {true, isPandigitalMultiple, 9, 5},
    {false, isPandigitalMultiple, 3, 3}
  }
}

function solve()
  local largestFound = 0

  local biggestNumberGuess = 10000
  for i=1, biggestNumberGuess do
    local biggestNGuess = 10
    for j=2, biggestNGuess do
      local success, product = isPandigitalMultiple(i, j)
      if success then
        largestFound = math.max(largestFound, tonumber(product))
      end
    end
  end

  return largestFound
end

helpers.benchmark(solve)