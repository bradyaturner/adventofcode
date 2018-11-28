#!/usr/bin/env ruby

class DayOneSolver
  def initialize(path)
    @characters = File.read(path).delete("\n").split("")
    @sum = 0
  end

  def solve
    @characters.each_with_index do |c,i|
      @sum += c.to_i if c==@characters[get_compared(i)]
    end
    puts "Solution: #{@sum}" 
  end
end

class D1P1Solver < DayOneSolver
  def get_compared(i)
    (i+1) % @characters.length
  end 
end

class D1P2Solver < DayOneSolver
  def get_compared(i)
    (i+@characters.length/2) % @characters.length
  end
end

path = "input.txt"
D1P1Solver.new(path).solve
D1P2Solver.new(path).solve
