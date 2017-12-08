#!/usr/bin/env ruby

class DayEightSolver
  def initialize(path)
    @path = path
    @file = File.read @path
    @registers = Hash.new 0
    @historical_max = 0
    interpret_file
  end

  def interpret_file
    @file.each_line {|line| parse_instruction line}
  end

  def parse_instruction(ins)
    parts = ins.split
    reg, op, amt = parts[0], parts[1], parts[2].to_i
    creg, comp, cval = parts[4], parts[5], parts[6].to_i
    eval("@registers[reg] #{op=="inc" ? "+=":"-="} amt if @registers[creg] #{comp} cval")
  end
end

class D8P1Solver < DayEightSolver
  def solve
    puts "P1 Solution(#{@path}): #{@registers.values.max}\n\n"
  end
end

class D8P2Solver < DayEightSolver
  def solve
    puts "P2 Solution(#{@path}): #{@historical_max}\n\n"
  end
  def parse_instruction(ins)
    super
    @historical_max = @registers.values.max if (@registers.values.max||0) > @historical_max
  end
end

testpath = "testinput.txt"
path = "input.txt"
D8P1Solver.new(testpath).solve
D8P1Solver.new(path).solve
D8P2Solver.new(testpath).solve
D8P2Solver.new(path).solve
