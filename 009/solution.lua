function isCorrectTriplet(a, b, c)
  return a < b
    and b < c
    and a ^ 2 + b ^ 2 == c ^ 2
    and a + b + c == 1000
end

for a=1, 1000 do
  for b=a+1, 1000 do
    local c=1000-(a+b)
    if isCorrectTriplet(a, b, c) then
      print(a, b, c, a*b*c)
      goto exit
    end
  end
end

::exit::