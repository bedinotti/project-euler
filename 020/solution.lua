local helpers = loadfile("helpers.lua")()

function factorial(n, product)
  if n == 1 then
    return product
  end
  return factorial(n - 1, product * n)
end

function sumDigitsIn(number)
  local str = string.format("%.f", number)
  local sum = 0
  for i=1, #str do
    sum = sum + tonumber(string.sub(str, i, i))
  end
  return sum
end

function factorialDigitSum(n)
  local product = factorial(n, 1.0)
  return sumDigitsIn(product)
end

helpers.expect(27, factorialDigitSum, 10)

helpers.benchmark(factorialDigitSum, 100)