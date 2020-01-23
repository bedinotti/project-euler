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

-- Example function
function solve(arg1)
  return "solution"
end

-- example of `benchmark`
benchmark(solve, 100000)