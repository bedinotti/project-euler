local helpers = loadfile("helpers.lua")()

-- Define a max heap data structure
-- For now, it's an array with insertion sort. Largest value at the end.
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
  local depth = node.row
  while index <= #self.nodes and value == self.nodes[index].value and depth > self.nodes[index].row do
    index = index + 1
  end
  table.insert(self.nodes, index, node)
end

function Heap:pop()
  if #self.nodes == 0 then return nil end
  local node = self.nodes[#self.nodes]
  self.nodes[#self.nodes] = nil
  return node
end

function Heap:isEmpty()
  return #self.nodes == 0
end

shouldPrintDebug = false
function debug(...)
  if shouldPrintDebug then
    print(...)
  end
end

-- Example solution function
function parseTable(input)
  local rows = {}
  for line in string.gmatch(input, "[%d ]+") do
    local column = {}
    for digits in string.gmatch(line, "%d+") do
      column[#column + 1] = {
        row = #rows + 1,
        column = #column + 1,
        children = {},
        value = tonumber(digits)
      }
    end
    rows[#rows + 1] = column
  end

  for rowIndex=2, #rows do
    local row = rows[rowIndex]
    for col=1, #row do
      local thisNode = rows[rowIndex][col]
      local previousRowSameColumn = rows[rowIndex-1][col]
      local previousRowPreviousColumn = rows[rowIndex-1][col-1]
      if previousRowSameColumn then
        table.insert(previousRowSameColumn.children, thisNode)
      end

      if previousRowPreviousColumn then
        table.insert(previousRowPreviousColumn.children, thisNode)
      end
    end
  end

  return rows[1][1]
end

function traceAndAccumulate(fromNode)
  local parent = fromNode["parent"]
  debug("Tracing ..")
  local sum = fromNode.value
  debug(sum)
  while parent do
    sum = sum + parent.value
    debug("+ " .. parent.value, sum)
    parent = parent["parent"]
  end
  return sum
end

function solve(pyramidString)
  local root = parseTable(pyramidString)
  -- Start at the last row. Add each row above it.
  local openSet = Heap:new()
  openSet:push(root)

  while not openSet:isEmpty() do
    local nextNode = openSet:pop()
    if #nextNode.children == 0 then
      return traceAndAccumulate(nextNode)
    end

    for childIndex=1, #nextNode.children do
      local child = nextNode.children[childIndex]
      if not child["parent"] then
        child["parent"] = nextNode
      end
      openSet:push(child)
    end
  end
  
  return 0
end

local easyInput = [[3
7 4
2 4 6
8 5 9 3]]
helpers.expect(23, solve, easyInput)

-- helpers.benchmark(solve, 100000)