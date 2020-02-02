local helpers = loadfile("helpers.lua")()

function valueOf(name, position)
  position = position or 1
  name = string.upper(name)
  local capitalAOffset = 64 -- 65 in ascii - 1 to keep it one indexed
  local sum = 0
  for i=1, #name do
    sum = sum + string.byte(name, i) - capitalAOffset
  end
  return sum * position
end

print("\nTest the name evaluation function")
helpers.expect(53, valueOf, "COLIN")
helpers.expect(49714, valueOf, "COLIN", 938)