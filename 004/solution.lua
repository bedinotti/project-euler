function is_palindrome(number)
  local string = tostring(math.floor(number))
  return string == string.reverse(string)
end

biggest_product = 1
for x = 100, 999 do
  for y = 100, 999 do
    local product = x * y
    if is_palindrome(product) and product > biggest_product then
      biggest_product = product
    end
  end
end

print(biggest_product)


