#!/usr/bin/env ruby

class DayTwoSolver
  def initialize(path)
    @file = File.read path
    @sum = 0
  end

  def format_line(line)
    line.split(" ").map(&:to_i)
  end
end

class D2P1Solver < DayTwoSolver
  def solve
    @file.each_line do |line|
      minmax = format_line(line).minmax
      @sum += minmax[1] - minmax[0]
    end
    puts "Solution: #{@sum}"
  end
end

class D2P2Solver < DayTwoSolver
  def solve
    @file.each_line do |line|
      row = format_line(line).sort
      row.each_with_index do |v,i|
        continue if i == row.length
        row[i+1..row.length].each do |v2|
          r = v2.to_f/v
          @sum += r.to_i if r%1==0
        end
      end
    end
    puts "Solution: #{@sum}"
  end
end

path = "input.txt"
D2P1Solver.new(path).solve
D2P2Solver.new(path).solve
