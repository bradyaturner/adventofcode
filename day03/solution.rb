#!/usr/bin/env ruby

class DayThreeSolver
  def initialize(input)
    @input = input
  end

  def solve
    puts "Input: #{@input}"
    sqrt = Math.sqrt @input
    puts "Square root: #{sqrt}"
    ceil = sqrt.ceil
    puts "Ceiling: #{ceil}"
    next_num = (ceil%2==0) ? ceil+1 : ceil
    puts "Next odd number: #{next_num}"
    next_num_sq = next_num*next_num
    puts "Next num squared: #{next_num_sq}"
    num_diff = next_num_sq - @input
    puts "Difference between numbers: #{num_diff}"
    whole_sides = num_diff/next_num #integer division rounding down
    puts "Whole sides between numbers: #{whole_sides}"
    dist_to_center = 1 + ((next_num-1)/2)
    puts "Distance from outside to center: #{dist_to_center}"

    edge_distance = ((num_diff - (whole_sides*next_num)) - dist_to_center).abs
    puts "Edge distance: #{edge_distance}"

    total_distance = dist_to_center + edge_distance

    puts "Solution: #{total_distance}"
  end
end

input = 368078
DayThreeSolver.new(input).solve

