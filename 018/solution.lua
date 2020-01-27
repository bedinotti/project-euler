local helpers = loadfile("helpers.lua")()

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
  local pyramid = parseTable(pyramidString)
  -- Start at the last row. Add each row above it.
  local sums = pyramid[#pyramid]

  print(table.unpack(sums))

  local range = 1
  -- For each row
  for i = #pyramid-1, 1, -1 do
    local newRow = pyramid[i]
    -- Take each value
    for j=1, #newRow do
      -- And add it from its index, up to range
      for k=0, range do
        local index = j + k
        sums[index] = sums[index] + newRow[j]
      end
    end

    print(table.unpack(sums))
  end

  return math.max(table.unpack(sums))
end

local easyInput = [[3
7 4
2 4 6
8 5 9 3]]
helpers.expect(23, solve, easyInput)

helpers.benchmark(solve, 100000)