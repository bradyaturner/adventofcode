#!/usr/bin/env ruby

# The captcha requires you to review a sequence of digits (your puzzle input)
# and find the sum of all digits that match the next digit in the list. The
# list is circular, so the digit after the last digit is the first digit in
# the list.

file = File.read "input.txt"
@characters = file.delete("\n").split("")

def partone
  sum = 0
  @characters.each_with_index do |c,i|
    i2 = (i==@characters.length-1) ? 0 : i+1
    x = @characters[i2]
    sum += c.to_i if c == x
  end
  puts "Part 1 Solution: #{sum}"
end

# Now, instead of considering the next digit, it wants you to consider the
# digit halfway around the circular list. That is, if your list contains 10
# items, only include a digit in your sum if the digit 10/2 = 5 steps forward
# matches it. Fortunately, your list has an even number of elements.

def parttwo
  sum = 0
  @characters.each_with_index do |c,i|
    i2 = (i+@characters.length/2)%@characters.length
    x = @characters[i2]
    sum += c.to_i if c==x
  end
  puts "Part 2 Solution: #{sum}"
end

partone
parttwo
