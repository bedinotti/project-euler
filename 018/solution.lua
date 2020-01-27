local helpers = loadfile("helpers.lua")()

-- Define a max heap data structure
-- For now, it's an array with insertion sort. 
local Heap = {}
function Heap:new (o)
  o = o or {}
  -- self.utility = self.utility or function (node) return node.value end
  self.nodes = {}
  self.__index = self
  setmetatable(o, self)
  return o
end

function Heap:push(node)
  local value = node.value
  local index = 1
  while index <= #self.nodes and value > self.nodes[index].value do
    index = index + 1
  end
  table.insert(self.nodes, index, node)
end

function Heap:pop()
  print("pop", #self.nodes)
  if #self.nodes == 0 then return nil end
  local node = self.nodes[#self.nodes]
  self.nodes[#self.nodes] = nil
  return node
end

function Heap:isEmpty()
  return #self.nodes == 0
end

-- Define a Node
function newNode ()
end

-- Example solution function
function parseTable(input)
  local rows = {}
  for line in string.gmatch(input, "[%d ]+") do
    local column = {}
    for digits in string.gmatch(line, "%d+") do
      column[#column + 1] = tonumber(digits)
    end
    rows[#rows + 1] = column
  end
  return rows
end

function solve(pyramidString)
  -- local pyramid = parseTable(pyramidString)
  -- Start at the last row. Add each row above it.
  local openSet = Heap:new()
  -- openSet:push(pyramid[1][1])

  openSet:push{value = 5}
  openSet:push{value = 10}
  openSet:push{value = 2}

  print(openSet:pop().value)
  print(openSet:pop().value)
  print(openSet:pop().value)
  print((openSet:pop() or {}).value)
  
  return 0
end

local easyInput = [[3
7 4
2 4 6
8 5 9 3]]
helpers.expect(23, solve, easyInput)

-- helpers.benchmark(solve, 100000)