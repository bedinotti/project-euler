-- run `method` with any passed argument. Print result to method and time to run.
function benchmark(method, ...)
  local startTime = os.clock()
  local values = {method(...)}
  local endTime = os.clock()
  print(string.format("Solved in %.2fs", endTime - startTime))
  print(table.unpack(values))
  return table.unpack(values)
end

-- Example function to show off `benchmark`
function wasteTime(countTo)
  print("called with " .. countTo)
  local dict = {}
  for i=1, countTo do
    dict[i] = i
  end

  while #dict > 0 do
    table.remove(dict, 1)
  end
  return 
end

-- example of `benchmark`
benchmark(wasteTime, 100000)