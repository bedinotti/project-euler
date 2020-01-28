local helpers = loadfile("helpers.lua")()

shouldPrintDebug = false

function debug(...)
  if shouldPrintDebug then
    print(...)
  end
end

-- Take the input string and return a table
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

function solveWithBottomUpPruning(pyramidString)
  local rows = parseTable(pyramidString)
  for row = #rows, 2, -1 do
    debug("Looping over", row)
    for col = 1, #rows[row] - 1 do
      debug(row, col)
      local left = rows[row][col]
      local right = rows[row][col + 1]
      rows[row-1][col] = rows[row-1][col] + math.max(left, right)
    end
  end

  return rows[1][1]
end

-- Run the tests, then solve with a benchmark.
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