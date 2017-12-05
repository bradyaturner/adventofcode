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
      offset = arr[cur]
      arr[cur] += get_increment(offset)
      cur += offset
      steps += 1
      break if cur < 0 || cur >= arr.length
    end
    puts "Solution: #{steps}"
  end
end

class D5P1Solver < DayFiveSolver
  def get_increment(offset) 1 end
end

class D5P2Solver < DayFiveSolver
  def get_increment(offset)
    (offset>=3) ? -1 : 1
  end
end

path = "input.txt"
D5P1Solver.new(path).solve
D5P2Solver.new(path).solve
