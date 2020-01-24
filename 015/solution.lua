-- Benchmark methods. These help measure performance & make sure the function keeps running
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

-- Problem solution
function fastSolve(squareSize)
  local vertexCount = squareSize + 1

  -- The first row is one vertex: {1}. the second is 2 vertices, with 1 path to each: {1, 1}
  -- Start with the second row state and start iterating on the 3rd row.
  local vertexPathCount = {1, 1}
  for i = 3, vertexCount do
    local newPathCount = {1}
    for j = 1, #vertexPathCount - 1 do
      newPathCount[#newPathCount + 1] = vertexPathCount[j] + vertexPathCount[j+1]
    end
    newPathCount[#newPathCount + 1] = 1
    vertexPathCount = newPathCount
  end

  -- We're at the diagonal. Multiply the # of paths at each vertex and add them up.
  local sum = 0
  for i = 1, #vertexPathCount do
    sum = sum + (vertexPathCount[i] ^ 2)
  end

  return sum
end

benchmark(fastSolve, 20)
