-- run `method` with any passed argument. Print result to method and time to run.
function benchmark(method, ...)
  startTime = os.clock()
  local values = {method(...)}
  local endTime = os.clock()
  print(string.format("Solved in %.4fs", endTime - startTime))
  print(table.unpack(values))
  return table.unpack(values)
end

function expect(expectedOutput, method, ...)
  local result = method(...)
  if result == expectedOutput then
    print("Pass", ...)
  else
    print("Fail", ..., result)
  end
end

function ping(...)
  local diff = os.clock() - startTime
  print(string.format("%.4fs", diff), ...)
end

numberWords = {
  [1] = "one",
  [2] = "two",
  [3] = "three", 
  [4] = "four",
  [5] = "five",
  [6] = "six",
  [7] = "seven",
  [8] = "eight",
  [9] = "nine",
  [10] = "ten",
  [11] = "eleven",
  [12] = "twelve",
  [13] = "thirteen",
  [14] = "fourteen",
  [15] = "fifteen",
  [16] = "sixteen",
  [17] = "seventeen",
  [18] = "eighteen",
  [19] = "nineteen",
  [20] = "twenty",
  [30] = "thirty",
  [40] = "forty",
  [50] = "fifty",
  [60] = "sixty",
  [70] = "seventy",
  [80] = "eighty",
  [90] = "ninety",
  [100] = "onehundred",
  [1000] = "onethousand",
}

-- this only works up to 1,000 and only because I hardcoded 1000 in the numberWords table.
function lettersIn(number)
  local word = numberWords[number]
  if word then
    return #word
  end

  if number < 100 then
    local num = lettersIn(math.floor(number / 10) * 10)
    if number % 10 ~= 0 then
      num = num + lettersIn(number % 10)
    end
    return num
  end

  if number < 1000 then
    local num = lettersIn(math.floor(number / 100)) + #"hundred"
    if number % 100 ~= 0 then
      num = num + #"and" + lettersIn(number % 100)
    end
    return num
  end

  return 0
end

function addLettersTo(upperLimit)
  local sum = 0
  for i=1, upperLimit do
    sum = sum + lettersIn(i)
  end
  return sum
end

-- Tests
print("Testing lettersIn...")
expect(5, lettersIn, 3)
expect(#"ninetynine", lettersIn, 99)
expect(#"onehundred", lettersIn, 100)
expect(#"twohundred", lettersIn, 200)
expect(23, lettersIn, 342)
expect(20, lettersIn, 115)
expect(#"onethousand", lettersIn, 1000)
print("Testing addLettersTo...")
expect(19, addLettersTo, 5)

-- Benchmark run
benchmark(addLettersTo, 1000)
