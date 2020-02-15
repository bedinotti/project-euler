local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

-- Example solution function
function solve(arg1)
  return "solution"
end

helpers.benchmark(solve, 100000)