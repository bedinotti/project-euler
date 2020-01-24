-- run `method` with any passed argument. Print result to method and time to run.
function benchmark(method, ...)
  startTime = os.clock()
  local values = {method(...)}
  local endTime = os.clock()
  print(string.format("Solved in %.4fs", endTime - startTime))
  print(table.unpack(values))
  return table.unpack(values)
end

function ping(...)
  local diff = os.clock() - startTime
  print(string.format("%.4fs", diff), ...)
end

-- First approach: find all the paths via depth-first search
function makeGrid(size) 
  local grid = {}
  for i=1, size+1 do
    local column = {}
    for j=1, size+1 do
      column[j] = true
    end
    grid[i] = column
  end
  return grid
end


function depthFirstSearch(grid, x, y, pathCount)
  local point = (grid[x] or {})[y]

  if point == nil then
    return 0
  end
  if x == #grid and #grid[x] == y then
    return 1
  end

  return depthFirstSearch(grid, x+1, y, pathCount) + depthFirstSearch(grid, x, y+1, pathCount)
end

function solve(squareSize) 
  local grid = makeGrid(squareSize)
  return depthFirstSearch(grid, 1, 1, 0)
end

-- Second approach - count the # of paths to the diagonal.
function fastSolve(squareSize)
  local vertexCount = squareSize + 1
  -- Start with the second row. Simpler than having the base case in the loop.
  local vertexPathCount = {1, 1}
  for i = 3, vertexCount do
    local newPathCount = {1}
    for j = 1, #vertexPathCount - 1 do
      newPathCount[#newPathCount + 1] = vertexPathCount[j] + vertexPathCount[j+1]
    end
    newPathCount[#newPathCount + 1] = 1
    vertexPathCount = newPathCount
  end

  local sum = 0
  for i = 1, #vertexPathCount do
    sum = sum + (vertexPathCount[i] ^ 2)
  end

  return sum
end


-- for i=1, 20 do
--   print("solving " .. i)
--   benchmark(solve, i)
-- end
benchmark(fastSolve, 20)
-- print(1, fastSolve(1), fastSolve(1) == 2)
-- print(2, fastSolve(2), fastSolve(2) == 6)
