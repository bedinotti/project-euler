local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

-- Example solution function
function permuatationCount(values, targetValue)
  -- print("permCount called, tv: " .. targetValue)
  if targetValue == 0 then
    -- this base case is odd. Not sure about it. Leaving it for now.
    return 1
  elseif targetValue < 0 then
    return 0
  end

  local count = 0

  for i=1, #values do
    count = count + permuatationCount(values, targetValue - values[i])

    -- local value = values[i]
    -- print("Examining " .. value)

    -- local remainingTarget = targetValue
    -- while remainingTarget >= value do
    --   remainingTarget = remainingTarget - value
    --   count = count + permuatationCount(values, remainingTarget)
    -- end
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

-- helpers.benchmark(permuatationCount, {1, 2, 5, 10, 20, 50, 100, 200})