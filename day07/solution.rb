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
    @file = File.read path
    @programs = []
  end

  def solve
    lines = @file.split "\n"
    lines.each {|line| parse_line line }
    @programs.each {|p| puts p}
    find_root(@programs.first)
    puts "Solution: #{@root}"
  end

  def parse_line(line)
    parts = line.split(" -> ")
    name = parts[0].split[0]
    weight = parts[0].scan(REGEX).last.first.to_i
    children = parts[1].nil? ? [] : parts[1].tr(",","").split
    @programs << Program.new(name,weight,children)
  end

  def find_root(program)
    parent = @programs.select {|p2| p2.children.include? program.name }
    puts "find_root(#{program.name}): parent: #{parent.inspect}"
    if parent.length == 0
      puts "Program #{program.name} has no parent in tree."
      @root = program.name
    else
      find_root(parent.first)
    end
  end
end

class D7P1Solver < DaySevenSolver
end

#path = "testinput.txt"
path = "input.txt"
D7P1Solver.new(path).solve
