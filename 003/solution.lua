function prime_factors(number)
  local divisor = 2
  local primes = {}
  while number > 1 do
    if number % divisor == 0 then
      primes[#primes + 1] = divisor
      while number % divisor == 0 do
        number = number / divisor
      end
    end
    -- In an ideal world, I'd go to the next prime. I'm being lazy and going to the next integer.
    divisor = divisor + 1
  end
  return primes
end

-- Confirming the algorithm works, with the example number
-- local factors = prime_factors(13195) 
-- for i = 1, #factors do
--   print(factors[i])
-- end

-- Now do this bad boi. Print just the largest factor.
local factors = prime_factors(600851475143) 
print(factors[#factors])
