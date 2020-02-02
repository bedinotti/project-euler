local helpers = loadfile("helpers.lua")()

-- Compute the value of a name at a given position in the list
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

-- Load a list of names given the filename
function loadList(filename)
  io.input(filename)
  local input = io.read("all")
  local names = {}
  print(input)
  for name in string.gmatch(input, "\"%a+\"") do
    print("Found name:" .. name)
    names[#names + 1] = name
  end
  return names
end

print("\nTest the name evaluation function")
helpers.expect(53, valueOf, "COLIN")
helpers.expect(49714, valueOf, "COLIN", 938)

print("\nTest file loading")
helpers.expect(7, function(f) return #loadList(f) end, "small_names.txt")