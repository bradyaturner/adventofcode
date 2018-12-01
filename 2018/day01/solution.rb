#!/usr/bin/env ruby

class DayOneSolver
  def initialize(path)
    @file = File.read path
    @data = @file.split.map(&:to_i)
  end

  def solve
  end
end

class D1P1Solver < DayOneSolver
  def solve
    freq = @data.inject(&:+)
    puts "Solution: #{freq}"
  end
end

class D1P2Solver < DayOneSolver
  def solve
    freq = 0
    frequencies = []
    @data.cycle do |v|
      freq += v
      break if frequencies.include? freq
      frequencies << freq
    end
    puts "Solution: #{freq}"
  end
end

samplepath = "sampleinput.txt"
sample2path = "sampleinput2.txt"
path = "input.txt"

D1P1Solver.new(samplepath).solve
D1P1Solver.new(path).solve
D1P2Solver.new(sample2path).solve
D1P2Solver.new(path).solve
