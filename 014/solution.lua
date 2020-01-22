-- run `method` with any passed argument. Print result to method and time to run.
function benchmark(method, ...)
  local startTime = os.clock()
  local values = {method(...)}
  local endTime = os.clock()
  print(string.format("Solved in %.2fs", endTime - startTime))
  print(table.unpack(values))
  return table.unpack(values)
end

-- Implement collatz with tail recursion
function collatz(n, length)
  if n == 1 then
    return 1 + length
  end

  if n % 2 == 0 then
    n = n / 2
  else
    n = (3 * n) + 1
  end

  return collatz(n, length + 1)
end

function solveStartingNumber()
  local longestChain = 0
  local longestStartingNumber = 0
  for i=1, 999999 do
    local thisChain = collatz(i, 0)
    if thisChain > longestChain then
      longestChain = thisChain
      longestStartingNumber = i
    end

    if i % 10000 then
      print("Trying " .. i)
    end
  end
  print(string.format("%d generates a chain of length %d", longestStartingNumber, longestChain))
  return longestStartingNumber
end

benchmark(solveStartingNumber)
