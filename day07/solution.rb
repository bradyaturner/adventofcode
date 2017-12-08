#!/usr/bin/env ruby


REGEX = /.*\((.*)\)/

class Program
  attr_accessor :name, :weight, :children
  def initialize(name, weight, children=[])
    @name = name
    @weight = weight
    @children = children.nil? ? [] : children
  end

  def to_s
    "Name: #{@name}\tWeight: #{@weight}\tChildren: #{@children.inspect}"
  end
end

class DaySevenSolver
  def initialize(path)
    @path = path
    @file = File.read @path
    @programs = {}
    lines = @file.split "\n"
    lines.each {|line| parse_line line }
    find_root(@programs.first.last)
  end

  def parse_line(line)
    parts = line.split(" -> ")
    name = parts[0].split[0]
    weight = parts[0].scan(REGEX).last.first.to_i
    children = parts[1].nil? ? [] : parts[1].tr(",","").split
    @programs[name] = Program.new(name,weight,children)
  end

  def find_root(program)
    parent = @programs.select {|name,p2| p2.children.include? program.name }
    if parent.length == 0
      @root = program.name
    else
      find_root(parent.first.last)
    end
  end
end

class D7P2Solver < DaySevenSolver
  def solve
    check_balance @programs[@root]
    puts "P2 Solution(#{@path}): #{@balance_weight}\n\n"
  end

  def check_balance(program)
    weights = {}
    program.children.each {|c| weights[c] = get_weight(@programs[c])}
    counts = Hash.new 0
    weights.values.each {|w| counts[w] += 1 }
    if weights.values.uniq.length == 1
      return true
    else
      ub = weights.select {|name,weight| counts[weight] == 1}.first
      children_are_balanced = check_balance(@programs[ub.first])
      if children_are_balanced
        expected = weights.select {|name,weight| counts[weight] > 1}.first.last
        actual = ub.last
        @balance_weight = @programs[ub.first].weight + expected - actual
      end
    end
    return false
  end

  def get_weight(program)
    weight = program.weight
    program.children.each {|cn| weight += get_weight(@programs[cn])}
    weight
  end
end

class D7P1Solver < DaySevenSolver
  def solve
    puts "P1 Solution(#{@path}): #{@root}\n\n"
  end
end

testpath = "testinput.txt"
path = "input.txt"
D7P1Solver.new(testpath).solve
D7P1Solver.new(path).solve
D7P2Solver.new(testpath).solve
D7P2Solver.new(path).solve

