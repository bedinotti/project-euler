primes = {}
function is_prime(n)
  for i=2, n-1 do
    if n % i == 0 then
      return false
    end
  end
  return true
end

function nth_prime(n)
  if primes[n] ~= nil then
    return primes[n]
  end
  for i=primes[#primes] or 2, math.huge do
    if is_prime(i) then
      primes[#primes + 1] = i
    end
    if #primes == n then
      return i
    end
  end
end


print(nth_prime(10001))
