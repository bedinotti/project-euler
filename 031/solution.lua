local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

-- Example solution function
function permuatationCount(values, targetValue)
  if targetValue == 0 and #values == 0 then
    return 1
  elseif targetValue < 0 then
    return 0
  end

  local count = 0

  if #values > 0 then
    local remainingValues = table.pack(table.unpack(values))
    -- Use the last value to reduce index updates
    local value = remainingValues[#remainingValues]
    table.remove(remainingValues, #remainingValues)

    local valueMultiple = 0
    while valueMultiple * value <= targetValue do
      count = count + permuatationCount(remainingValues, targetValue - valueMultiple * value)
      valueMultiple = valueMultiple + 1
    end
  end
  
  return count
end

helpers.testGroup {
  "permutationCount",
  tests = {
    {1, permuatationCount, {50}, 50},
    {2, permuatationCount, {50, 25}, 50},
    {3, permuatationCount, {50, 25}, 100},
  }
}

helpers.benchmark(permuatationCount, {1, 2, 5, 10, 20, 50, 100, 200}, 200)