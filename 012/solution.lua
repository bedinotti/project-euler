-- Store in this table, rather than in the global namespace
global = {}

-- run `method` with any passed argument. Print result to method and time to run.
function benchmark(method, ...)
  local startTime = os.clock()
  local values = {method(...)}
  local endTime = os.clock()
  print(string.format("Solved in %.2fs", endTime - startTime))
  print(table.unpack(values))
  return table.unpack(values)
end

-- From solution 10
-- function primesLessThan(upperBound)
--   return coroutine.wrap(function ()
--     local allNumbers = {}
--     for i = 1, upperBound - 1 do
--       allNumbers[#allNumbers + 1] = i
--     end
--     local maxIndex = #allNumbers

--     local index = 2
--     repeat
--       local nextPrime = allNumbers[index]
--       coroutine.yield(nextPrime)

--       for multiples = 2 * nextPrime, maxIndex, nextPrime do
--         allNumbers[multiples] = nil
--       end

--       repeat
--         index = index + 1
--       until allNumbers[index] ~= nil or index > maxIndex
--     until index > maxIndex
--   end)
-- end

function altDivisors(n)
  if n == 1 then return 1 end

  local divisorCount = 1

  local i = 2
  local originalN = n
  while n > 1 and i <= originalN do
    if n % i == 0 then
      local exponent = 0

      while n % i == 0 do
        exponent = exponent + 1
        n = n / i
      end

      divisorCount = divisorCount * (exponent + 1)
    end

    i = i + 1
  end

  return divisorCount
end

-- actual function to solve
function triangleWith(divisorMin)
  local triangles = coroutine.wrap(function ()
    local sum = 0
    for i=1, math.huge do
      sum = sum + i
      coroutine.yield(sum)
    end
  end)

  local count = 1
  for tri in triangles do
    if altDivisors(tri) > divisorMin then
      return tri
    end
    if count % 100 == 0 then
      print(string.format("Looking at %dth number", count))
    end
    count = count + 1
  end
end

benchmark(triangleWith, 500)
