#!/usr/bin/env ruby

class DayFiveSolver
  def initialize(path)
    @file = File.read(path)
    @banks = @file.split.map(&:to_i)
    @history = []
    @history << Array.new(@banks)
  end

  def redistribute
    i = @banks.index(@banks.max)
    val = @banks[i]
    @banks[i] = 0
    loop do
      @banks[(i+=1) % @banks.length] += 1
      val -= 1
      break if val == 0
    end
  end

  def solve
    count = 0
    loop do
      redistribute
      count += 1
      break if @history.include? @banks
      @history << Array.new(@banks)
    end
    puts "Solution: #{count}"
  end
end

path = "input.txt"
DayFiveSolver.new(path).solve
