#!/usr/bin/env ruby

require './computer'

class Day19Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    @computer = Computer.new
    parse_input
  end

  def parse_input
    instructions = []
    lines = @file.lines
    ip = lines.shift.split.last.to_i
    @computer.bind_ip ip
    lines.each {|l| instructions << Instruction.new(l)}
    @computer.load_instructions instructions
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D19P1Solver < Day19Solver
  def solve
    @computer.run
    @solution = @computer.reg[0]
    super
  end
end

class D19P2Solver < Day19Solver
  def solve
    @computer.set_registers([1,0,0,0,0,0])
    @computer.run(1000)
    val = @computer.reg.max
    factors = (1..val).select {|n| val%n == 0}
    @solution = factors.sum
    super
  end
end

samplepath = "sampleinput.txt"
path = "input.txt"

D19P1Solver.new(samplepath).solve
D19P1Solver.new(path).solve
D19P2Solver.new(samplepath).solve
D19P2Solver.new(path).solve
