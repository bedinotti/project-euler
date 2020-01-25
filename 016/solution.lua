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

function solve(power)
  local num 
  -- Use faster bit shifting for smaller numbers that fit in an integer
  if power < 63 then
    num = 1 << power
  else
    num = 2 ^ power
  end

  local str = string.format("%.f", num)
  local sum = 0
  for i=1, #str do
    sum = sum + tonumber(string.sub(str, i, i))
  end
  return sum
end

benchmark(solve, 1000)