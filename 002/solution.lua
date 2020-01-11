-- Define a fibonacci coroutine that yields each number in a fibonacci sequence
fibco = coroutine.create (function()
  local current = 1
  local previous = 1
  coroutine.yield(1)

  while true do
    local sum = current + previous
    coroutine.yield(sum)
    previous = current
    current = sum
  end
end)

sum = 0
repeat
  _, val = coroutine.resume(fibco)
  if val % 2 == 0 then
    sum = sum + val
  end
until val > 4000000

print(sum)
