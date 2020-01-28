local helpers = loadfile("helpers.lua")()

shouldPrintDebug = false

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
  local depth = node.row
  local index = 1
  while index <= #self.nodes and value > self.nodes[index].value do
    index = index + 1
  end
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

function debug(...)
  if shouldPrintDebug then
    print(...)
  end
end

-- Take the input string and return a tree/table
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

  return rows
end

-- These are methods used for my failed A* search approach.
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

function solveWithAStarSearch(pyramidString)
  local tree = parseTable(pyramidString)
  local root = tree[1][1]
  -- Start at the last row. Add each row above it.
  local openSet = Heap:new()
  openSet:push(root)

  while not openSet:isEmpty() do
    local nextNode = openSet:pop()
    debug("Popped " .. nextNode.value)
    if #nextNode.children == 0 then
      return traceAndAccumulate(nextNode)
    end

    for childIndex=1, #nextNode.children do
      local child = nextNode.children[childIndex]
      if not child.parent then
        debug("Most expensive parent to " .. child.value .. " is " .. nextNode.value) 
        child.parent = nextNode
        openSet:push(child)
      end
    end
  end
  
  return 0
end

function solveWithBottomUpPruning(pyramidString)
  local rows = parseTable(pyramidString)
  for row = #rows, 2, -1 do
    debug("Looping over", row)
    for col = 1, #rows[row] - 1 do
      debug(row, col)
      local left = rows[row][col]
      local right = rows[row][col + 1]
      local parent = rows[row-1][col]
      parent.value = parent.value + math.max(left.value, right.value)
    end
  end

  return rows[1][1].value
end

-- local solve = solveWithAStarSearch
local solve = solveWithBottomUpPruning
local easyInput = [[3
7 4
2 4 6
8 5 9 3]]
helpers.expect(23, solve, easyInput)

local challengeInput = [[75
95 64
17 47 82
18 35 87 10
20 04 82 47 65
19 01 23 75 03 34
88 02 77 73 07 63 67
99 65 04 28 06 16 70 92
41 41 26 56 83 40 80 70 33
41 48 72 33 47 32 37 16 94 29
53 71 44 65 25 43 91 52 97 51 14
70 11 33 28 77 73 17 78 39 68 17 57
91 71 52 38 17 14 91 43 58 50 27 29 48
63 66 04 68 89 53 67 30 73 16 69 87 40 31
04 62 98 27 23 09 70 98 73 93 38 53 60 04 23]]

helpers.benchmark(solve, challengeInput)