#!/usr/bin/env ruby

class DayOneSolver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @data = @file.split.map(&:to_i)
    @solution
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D1P1Solver < DayOneSolver
  def solve
    @solution = @data.inject(&:+)
    super
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
    @solution = freq
    super
  end
end

samplepath = "sampleinput.txt"
sample2path = "sampleinput2.txt"
path = "input.txt"

D1P1Solver.new(samplepath).solve
D1P1Solver.new(path).solve
D1P2Solver.new(sample2path).solve
D1P2Solver.new(path).solve
