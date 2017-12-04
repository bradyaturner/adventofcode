#!/usr/bin/env ruby

class DayFourSolver
  def initialize(path)
    @file = File.read(path)
  end

  def solve
    num_valid = 0
    @file.each_line do |line|
      words = line.split.map { |word| get_word(word) }
      num_valid += 1 if words == words.uniq
    end
    puts "Solution: #{num_valid}"
  end
end

class D4P1Solver < DayFourSolver
  def get_word(word) word end
end

class D4P2Solver < DayFourSolver
  def get_word(word)
    word.chars.sort.join
  end
end

path = "input.txt"
D4P1Solver.new(path).solve
D4P2Solver.new(path).solve
