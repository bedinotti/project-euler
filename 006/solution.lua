function findDiffUntil(maxNum)
  local squaredSum = 0
  for i=1, maxNum do
    squaredSum = squaredSum + i ^ 2
  end

  local sum = 0
  for i=1, maxNum do
    sum = sum + i
  end
  local sumSquared = sum ^ 2

  return sumSquared - squaredSum
end

print(findDiffUntil(100))
