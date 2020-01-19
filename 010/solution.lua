function primesLessThan(upperBound)
  return function ()
    local allNumbers = {}
    for i = 2, upperBound - 1 do
      allNumbers[#allNumbers + 1] = i
    end
    local maxIndex = #allNumbers

    local index = 1
    repeat
      local nextPrime = allNumbers[index]
      coroutine.yield(nextPrime)

      for multiples = 2 * nextPrime, maxIndex, nextPrime do
        local matchingIndex = multiples - 1
        allNumbers[matchingIndex] = nil
      end

      repeat
        index = index + 1
        if index % 10000 == 0 then
          print("At index " .. index)
        end
      until allNumbers[index] ~= nil or index > maxIndex
    until index > maxIndex
  end
end

function primesIterator(upperBound)
  return coroutine.wrap(primesLessThan(upperBound))
end

local sum = 0
for prime in primesIterator(2000000) do
  sum = sum + prime
end
print(sum)
