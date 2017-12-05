#!/usr/bin/env ruby

class DayFiveSolver
  def initialize(path)
    @file = File.read path
  end

  def solve
    cur = 0
    arr = @file.split.map(&:to_i)
    steps = 0
    loop do
      inc = arr[cur]
      arr[cur] += 1
      cur += inc
      steps += 1
      break if cur < 0 || cur >= arr.length
    end
    puts "Solution: #{steps}"
  end
end

path = "input.txt"
DayFiveSolver.new(path).solve
