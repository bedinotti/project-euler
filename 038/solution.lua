local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

-- Example solution function
function isPandigitalMultiple(number, n)
  local products = {}
  for mult=1, n do
    products[#products + 1] = string.format("%d", mult * number)
  end
  local str = table.concat(products)
  local digits = {}
  for i=1, #str do
    digits[#digits + 1] = string.sub(str, i, i)
  end
  table.sort(digits)

  return table.concat(digits) == "123456789"
end

helpers.testGroup{
  "isPandigitalMultiple",
  tests = {
    {true, isPandigitalMultiple, 192, 3},
    {true, isPandigitalMultiple, 9, 5},
    {false, isPandigitalMultiple, 3, 3}
  }
}

-- helpers.benchmark(solve, 100000)