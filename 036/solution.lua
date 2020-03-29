local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

local hexToBinary = {}
hexToBinary["0"] = "0000"
hexToBinary["1"] = "0001"
hexToBinary["2"] = "0010"
hexToBinary["3"] = "0011"
hexToBinary["4"] = "0100"
hexToBinary["5"] = "0101"
hexToBinary["6"] = "0110"
hexToBinary["7"] = "0111"
hexToBinary["8"] = "1000"
hexToBinary["9"] = "1001"
hexToBinary["A"] = "1010"
hexToBinary["B"] = "1011"
hexToBinary["C"] = "1100"
hexToBinary["D"] = "1101"
hexToBinary["E"] = "1110"
hexToBinary["F"] = "1111"

function isPalindrome(str)
  return str == string.reverse(str)
end

function toBinary(decimalNumber)
  local hexString = string.format("%X", decimalNumber)

  local bytes = {}
  for i=1, #hexString do
    local hexLetter = string.sub(hexString, i, i)
    local binary = hexToBinary[hexLetter]
    bytes[#bytes + 1] = binary
  end

  local binaryString = table.concat(bytes)
  local startIndex, endIndex = string.find(binaryString, "0+")
  if startIndex == 1 then
    binaryString = string.sub(binaryString, endIndex + 1, -1)
  end

  return binaryString
end


helpers.testGroup{
  "toBinary",
  tests = {
    {"1010", toBinary, 10},
    {"10001", toBinary, 17}
  }
}

function isDoublePalindrome(number)
  return isPalindrome(tostring(number)) and isPalindrome(toBinary(number))
end

function findDoublePalindromeSumLessThan(maxBounds)
  local sum = 0
  for i=1, maxBounds - 1 do
    if isDoublePalindrome(i) then
      sum = sum + i
    end
  end
  return sum
end

helpers.benchmark(findDoublePalindromeSumLessThan, 1000000)