#!/usr/bin/env ruby

class DayEightSolver
  def initialize(path)
    @path = path
    @file = File.read @path
  end

  def interpret_file
    @registers = Hash.new 0
    @file.each_line {|line| parse_instruction line}
    @solution = @registers.values.max
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
    
    @registers[creg] = 0 if @registers[creg].nil?
    eval("@registers[reg] #{op=="inc" ? "+=":"-="} amt if @registers[creg] #{comp} cval")
  end

  def solve
    interpret_file
    puts "Solution(#{@path}): #{@solution}\n\n"
  end
end

class D8P1Solver < DayEightSolver
end

testpath = "testinput.txt"
path = "input.txt"
D8P1Solver.new(testpath).solve
D8P1Solver.new(path).solve
