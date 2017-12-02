#!/usr/bin/env ruby

# The captcha requires you to review a sequence of digits (your puzzle input)
# and find the sum of all digits that match the next digit in the list. The
# list is circular, so the digit after the last digit is the first digit in
# the list.

file = File.read "input.txt"
@sum = 0
characters = file.delete("\n").split("")
characters.each_with_index do |c,i|
  i2 = (i==characters.length-1) ? 0 : i+1
  x = characters[i2]
  @sum += c.to_i if c == x
end
puts @sum
