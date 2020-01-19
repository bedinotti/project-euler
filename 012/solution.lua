-- run `method` with any passed argument. Print result to method and time to run.
function benchmark(method, ...)
  local startTime = os.clock()
  print(method(...))
  local endTime = os.clock()
  print(string.format("Solved in %.2fs", endTime - startTime))
end

function divisors(number)
  local divs = {}
  for i=1, number do
    if number % i == 0 then
      divs[#divs + 1] = i
    end
  end

  return #divs
end

function triangleWith(divisorMin)
  local triangles = coroutine.wrap(function ()
    local sum = 0
    for i=1, math.huge do
      sum = sum + i
      coroutine.yield(sum)
    end
  end)

  for tri in triangles do
    if divisors(tri) > divisorMin then
      return tri
    end
  end
end

benchmark(triangleWith, 500)