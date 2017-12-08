#!/usr/bin/env ruby

class DayEightSolver
  def initialize(path)
    @path = path
    @file = File.read @path
    @historical_max = 0
    interpret_file
  end

  def interpret_file
    @registers = Hash.new 0
    @file.each_line {|line| parse_instruction line}
  end

  def parse_instruction(ins)
    parts = ins.split

    reg = parts[0]
    op = parts[1]
    amt = parts[2].to_i

    # conditional
    creg = parts[4]
    comp = parts[5]
    cval = parts[6].to_i

    eval("@registers[reg] #{op=="inc" ? "+=":"-="} amt if @registers[creg] #{comp} cval")
    @historical_max = @registers.values.max if @registers.values.length > 0 && @registers.values.max > @historical_max
  end
end

class D8P1Solver < DayEightSolver
  def solve
    @solution = @registers.values.max
    puts "P1 Solution(#{@path}): #{@solution}\n\n"
  end
end

class D8P2Solver < DayEightSolver
  def solve
    @solution = @historical_max
    puts "P2 Solution(#{@path}): #{@solution}\n\n"
  end
end

testpath = "testinput.txt"
path = "input.txt"
D8P1Solver.new(testpath).solve
D8P1Solver.new(path).solve
D8P2Solver.new(testpath).solve
D8P2Solver.new(path).solve
