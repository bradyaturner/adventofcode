#!/usr/bin/env ruby

class DaySixSolver
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
      break if check
      update(count)
      @history << Array.new(@banks)
    end
    puts "Solution: #{count - offset}"
  end
end

class D6P1Solver < DaySixSolver
  def check
    @history.include? @banks
  end

  def update(count)
  end

  def offset
    0
  end
end

class D6P2Solver < DaySixSolver
  def check
    @banks == @known
  end

  def update(count)
    if (@history.include?(@banks) && @known.nil?)
      @known = Array.new(@banks)
      @first_count = count
    end
  end

  def offset
    @first_count
  end
end

path = "input.txt"
D6P1Solver.new(path).solve
D6P2Solver.new(path).solve
