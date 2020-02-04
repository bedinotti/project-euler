local function benchmark(method, ...)
  startTime = os.clock()
  local values = {method(...)}
  local endTime = os.clock()
  print(string.format("Solved in %.4fs", endTime - startTime))
  print(table.unpack(values))
  return table.unpack(values)
end

local function ping(...)
  local diff = os.clock() - startTime
  print(string.format("%.4fs", diff), ...)
end

local function expect(expectedOutput, method, ...)
  local result = method(...)
  if result == expectedOutput then
    print("Pass", ...)
  else
    print("Fail", ..., result)
  end
end

return {
  benchmark = benchmark,
  ping      = ping,
  expect    = expect
}