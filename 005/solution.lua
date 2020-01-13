product = 2520

-- Return true if `number` is evenly divisible by all integers from ` to `divisor`.
function divides_up_to(number, divisor)
  for i = 1, divisor do
    if number % i ~= 0 then
      return false
    end
  end
  return true
end

-- naive solution. Just try every number until you find one 
function smallest_multiple(max)
  for i = 1, math.huge do
    if divides_up_to(i, max) then
      return i
    end
  end
  return -1
end

-- This works, but it takes soo long to run.
-- print(smallest_multiple(20))

-- This second technique should be faster. Rather than find it, let's compute it.
-- Find the prime factorization of all of the numbers you need, then combine them
function prime_factors(number)
  local factors = {}
  for i = 2, number do
    local power = 0
    if number % i == 0 then
      while number % i == 0 do
        number = number / i
        power = power + 1
      end
    end
    if power > 0 then
      factors[i] = power
    end
  end
  return factors
end

function fast_smallest_multiple(max)
  local all_factors = {}
  for i = 2, max do
    local factors = prime_factors(i)
    for k, v in pairs(factors) do
      local existing_power = all_factors[k]
      if existing_power == nil or existing_power < v then
        all_factors[k] = v
      end
    end
  end

  local product = 1
  for k, v in pairs(all_factors) do
    product = product * k ^ v
  end
  return product
end

print(fast_smallest_multiple(20))
