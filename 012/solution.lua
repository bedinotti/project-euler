-- run `method` with any passed argument. Print result to method and time to run.
function benchmark(method, ...)
  local startTime = os.clock()
  print(method(...))
  local endTime = os.clock()
  print(string.format("Solved in %.2fs", endTime - startTime))
end

-- From solution 10
function primesLessThan(upperBound)
  return coroutine.wrap(function ()
    local allNumbers = {}
    for i = 1, upperBound - 1 do
      allNumbers[#allNumbers + 1] = i
    end
    local maxIndex = #allNumbers

    local index = 2
    repeat
      local nextPrime = allNumbers[index]
      coroutine.yield(nextPrime)

      -- print("eliminating multiples of " .. nextPrime)
      for multiples = 2 * nextPrime, maxIndex, nextPrime do
        -- local matchingIndex = multiples
        -- print("eliminating index " .. matchingIndex .. " value " .. allNumbers[matchingIndex])
        allNumbers[multiples] = nil
      end

      repeat
        index = index + 1
      until allNumbers[index] ~= nil or index > maxIndex
      -- print("index is" .. index .. "for maxindex" .. maxIndex)
    until index > maxIndex
  end)
end

function divisors(number)
  if number == 1 then
    return 1
  end

  local count = 1
  -- print("primes less than " .. (number+1))
  for prime in primesLessThan(number + 1) do
    -- print("prime is" .. prime)
    if number % prime == 0 then
      -- print("trying prime " .. prime .. "for number " .. number)
      local exponent = 0
      local copy = number
      while copy % prime == 0 do
        copy = copy / prime
        exponent = exponent + 1
      end

      -- print("  " .. prime .. "^" .. exponent)
      count = count * (exponent + 1)
    end
  end

  return count
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

-- print(divisors(6))
-- print(1, divisors(1) == 1)
-- print(3, divisors(3) == 2)
-- print(6, divisors(6) == 4)
-- print(10, divisors(10) == 4)
-- print(15, divisors(15) == 4)
-- print(21, divisors(21) == 4)
-- print(28, divisors(28) == 6)