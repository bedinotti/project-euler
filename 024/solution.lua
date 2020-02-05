local helpers = loadfile("helpers.lua")()

function orderedPermutationsOf(digitList)
  if #digitList == 1 then
    return {tostring(digitList[1])}
  end

  local result = {}
  for i=1, #digitList do
    local digitToPrepend = digitList[i]
    local copy = {table.unpack(digitList)}
    table.remove(copy, i)
    local otherPerms = orderedPermutationsOf(copy)

    for j=1, #otherPerms do
      result[#result + 1] = digitToPrepend .. otherPerms[j]
    end
  end

  return result
end

function millionthPermutation()
  local result = orderedPermutationsOf{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
  return result[1000000]
end

helpers.benchmark(millionthPermutation)
