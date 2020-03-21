local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

-- Example solution function
function permuatationCount(values, targetValue)
  -- print("permCount, values:" .. table.concat(values, ",") .. " tv:" .. targetValue)
  if targetValue == 0 and #values == 0 then
    -- this base case is odd. Not sure about it. Leaving it for now.
    -- print("returning 1")
    return 1
  elseif targetValue < 0 then
    -- print("returning 0")
    return 0
  end

  local count = 0

  local remainingValues = table.pack(table.unpack(values))
  if #remainingValues > 0 then
    local value = remainingValues[1]
    table.remove(remainingValues, 1)

    local valueMultiple = 0
    while valueMultiple * value <= targetValue do
      -- print("trying " .. valueMultiple .. " * " .. value)
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