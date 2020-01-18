function primesLessThan(upperBound)
  return function ()
    local allNumbers = {}
    for i = 2, upperBound do
      allNumbers[#allNumbers + 1] = i
    end
    
    local index = 1
    repeat
      local nextPrime = allNumbers[index]
      coroutine.yield(nextPrime)

      local indexesToRemove = {}
      for i = index + 1, #allNumbers do
        local numberToCheck = allNumbers[i]
        if numberToCheck % nextPrime == 0 then
          table.insert(indexesToRemove, i)
        end
      end

      for i = #indexesToRemove, 1, -1 do
        local index = indexesToRemove[i]
        table.remove(allNumbers, index)
      end

      index = index + 1
    until index > #allNumbers
  end
end

function primesIterator(upperBound)
  return coroutine.wrap(primesLessThan(upperBound))
end

local sum = 0
for prime in primesIterator(10) do
  print(prime)
  sum = sum + prime
end
print(sum)
