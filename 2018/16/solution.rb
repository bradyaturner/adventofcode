#!/usr/bin/env ruby

require 'json'
require './wristcomputer'

class Day16Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    @wrist_computer = WristComputer.new
    parse_input
  end

  def parse_input
    @tests = []
    lines = @file.lines
    loop do
      snippet = lines.shift(4)
      before, instruction, after = snippet[0..2]
      before = before[9..-2].split(", ").map(&:to_i)
      after = after[9..-2].split(", ").map(&:to_i)

      @tests << OpTest.new(before, instruction, after)
      break if lines.length == 0
    end
  end

  def test_instructions
    @candidates = {}
    count = 0
    @tests.each do |t|
      @candidates[t.instruction.op] = {:pass => [], :fail => []} if !@candidates[t.instruction.op]
      ins_count = 0
      INSTRUCTIONS.each do |ins|
        @wrist_computer.set_registers(t.before)
        @wrist_computer.process_instruction(ins, t.instruction.a, t.instruction.b, t.instruction.out)
        if (@wrist_computer.reg == t.after)
          @candidates[t.instruction.op][:pass] << ins
          ins_count += 1
        else
          @candidates[t.instruction.op][:fail] << ins
        end
      end
      count += 1 if ins_count >= 3
    end
    count
  end

  def unsolved_candidates
    @candidates.select{|op,c| c[:valid].length > 1}
  end

  def process_test_results
    loop do
      solved = @candidates.select{|op, c| c[:valid].length == 1}
      solved.each do |op, c|
        unsolved_candidates.each do |op2, c2|
          c2[:valid] -= c[:valid]
        end
      end
      break if unsolved_candidates.length == 0
    end
    instructions = {}
    @candidates.map{|op, c| instructions[op] = c[:valid].first}
    instructions
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D16P1Solver < Day16Solver
  def solve
    @solution = test_instructions
    super
  end
end

class D16P2Solver < Day16Solver
  def initialize(path, instructionspath)
    ins_file = File.read instructionspath
    @instructions = []
    ins_file.each_line {|l| @instructions << Instruction.new(l)}
    super(path)
  end

  def solve
    test_instructions
    @candidates.map {|op, c| c[:valid] = c[:pass].uniq - c[:fail].uniq }
    ins_map = process_test_results
    @wrist_computer.set_instruction_map ins_map
    @wrist_computer.set_registers([0,0,0,0])
    @instructions.each {|i| @wrist_computer.process_opcode(i.op, i.a, i.b, i.out)}
    @solution = @wrist_computer.reg[0]
    super
  end
end

samplepath = "sampleinput.txt"
path = "input.txt"
instructionspath = "instructionsinput.txt"

D16P1Solver.new(samplepath).solve
D16P1Solver.new(path).solve
D16P2Solver.new(path, instructionspath).solve
