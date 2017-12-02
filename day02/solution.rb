#!/usr/bin/env ruby

class DayTwoSolver
  def initialize(path)
    @file = File.read path
    @sum = 0
  end

  def solve
    @file.each_line do |line|
      minmax = line.split(" ").map(&:to_i).minmax
      @sum += minmax[1] - minmax[0]
    end
    puts "Solution: #{@sum}"
  end
end

path = "input.txt"
DayTwoSolver.new(path).solve
