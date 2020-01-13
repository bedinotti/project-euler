product = 2520

function divides_up_to(number, divisor)
  for i = 1, divisor do
    if number % i ~= 0 then
      return false
    end
  end
  return true
end

function smallest_multiple(max)
  for i = 1, math.huge do
    if divides_up_to(i, max) then
      return i
    end
  end
  return -1
end

print(smallest_multiple(20))
