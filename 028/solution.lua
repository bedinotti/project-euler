local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

-- Example solution function
function diagonalSum(sideLength)
  local lastSeenCell = 0
  local sum = 0

  for side = 1, sideLength, 2 do
    if side == 1 then
      -- This is special, because all four corners are the same number, counted only once.
      lastSeenCell = 1
      sum = sum + lastSeenCell
    else
      local bottomRight = side + lastSeenCell - 1
      local bottomLeft = bottomRight + side - 1
      local topLeft = bottomLeft + side - 1
      local topRight = topLeft + side - 1
      lastSeenCell = topRight
      sum = sum + bottomRight + bottomLeft + topLeft + topRight
    end
  end

  return sum
end

helpers.testGroup {
  "diagonalSum",
  tests = {
    {1, diagonalSum, 1},
    {25, diagonalSum, 3},
    {101, diagonalSum, 5}
  }
}

helpers.benchmark(diagonalSum, 1001)