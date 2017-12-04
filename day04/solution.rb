#!/usr/bin/env ruby

class DayFourSolver
  def initialize(path)
    @file = File.read(path)
  end

  def solve
    num_valid = 0
    @file.each_line do |line|
      valid = true
      words = line.split
      counts = Hash.new 0
      words.each { |word| counts[word] += 1 }
      counts.each { |word,count| valid = false if count > 1 }
      num_valid += 1 if valid
    end
    puts "Solution: #{num_valid}"
  end
end

path = "input.txt"
DayFourSolver.new(path).solve
