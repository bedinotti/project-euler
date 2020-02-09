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

-- Test a group of inputs & outputs. 
local function testGroup(input)
  local title = input[1] or input.title or ""
  if input.skip then
    print(string.format("Skipping %s...", title))
    return
  else
    print(string.format("Testing %s...", title))
  end
  local tests = input.tests or {}
  if #tests == 0 then
    print("No tests found.")
  end
  for i=1, #(tests) do
    expect(table.unpack(input.tests[i]))
  end
  print()
end

return {
  benchmark = benchmark,
  ping      = ping,
  expect    = expect,
  testGroup = testGroup
}