local helpers = loadfile("helpers.lua")()

function solve()
  local totalDays = 0
  local firstSundays = 0
  local daysInAYear = {31, 28, 31, 30, 31, 30, 
                       31, 31, 30, 31, 30, 31}
  for year = 1901, 2000 do
    for month = 1, #daysInAYear do
      local daysInMonth = daysInAYear[month]
      if month == 2 then
        local leapDay = 0
        if (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0) then
          leapDay = 1
        end
        daysInMonth = daysInMonth + leapDay
      end

      if totalDays % 7 == 0 then
        firstSundays = firstSundays + 1
      end
      totalDays = totalDays + daysInMonth
    end
  end

  return firstSundays
end

helpers.benchmark(solve, 100000)