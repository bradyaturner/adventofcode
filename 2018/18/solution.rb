#!/usr/bin/env ruby

class Day18Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    parse_input
  end

  def parse_input
    lines = @file.lines
    @width = lines.first.strip.length
    @height = lines.length
    @grid = Array.new(@height){Array.new(@width)}
    lines.each_with_index do |l,y|
      l.strip.chars.each_with_index do |c,x|
        @grid[y][x] = c
      end
    end
  end

  def iterate
    new_grid = Array.new(@height){Array.new(@width)}
    @grid.each_with_index do |row,y|
      row.each_with_index do |v,x|
        adjacent = get_adjacent(x,y)
        new_grid[y][x] = if v == '.' && (adjacent.count('|') >= 3)
          '|'
        elsif v == '|' && (adjacent.count('#') >= 3)
          '#'
        elsif v == '#' && !(adjacent.count('#') >=1 && adjacent.count('|') >=1)
          '.'
        else
          get_value(x,y)
        end
      end
    end
    @grid = new_grid
  end

  def get_value(x,y)
    @grid[y][x]
  end

  def set_value(x,y,value)
    @grid[y][x] = value
  end

  def print_grid
    @grid.each do |row|
      row.each {|c| print c}
      print "\n"
    end
  end

  def in_bounds?(x,y)
    (x < @grid.first.length) && (x >= 0) &&
      (y < @grid.length) && (y >= 0)
  end

  def get_adjacent(x,y)
    adjacent = []
    (y-1..y+1).each do |y2|
      (x-1..x+1).each do |x2|
        next if x2==x && y2==y
        adjacent << get_value(x2,y2) if in_bounds?(x2,y2)
      end
    end
    adjacent.compact
  end

  def resource_value
    num_lumberyards = @grid.flatten.count("#")
    num_wooded = @grid.flatten.count("|")
    num_lumberyards * num_wooded
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D18P1Solver < Day18Solver
  def run(minutes)
    minutes.times do |i|
      iterate
    end
  end

  def solve
    run(10)
    @solution = resource_value
    super
  end
end

class D18P2Solver < Day18Solver
  def stabilized?(values, threshold)
    return false if values.length<100
    range = values[values.length-100..-1]
    diff = range.max - range.min
    diff <= threshold
  end

  def calculate_offset(values)
    values.length - 1 - values[0..-2].rindex(values.last)
  end

  def equivalent_index(values, index)
    offset = calculate_offset(values)
    distance = offset * ((index - values.length).to_f / offset).ceil
    index - distance - 1
  end

  def run(minutes)
    values = []
    stable_count = 0
    minutes.times do |i|
      iterate
      values << resource_value
      stable_count += 1 if stabilized?(values, 30000)
      break if stable_count > 200
    end
    @solution = values[equivalent_index(values,minutes)]
  end

  def solve
    run(1000000000)
    super
  end
end

samplepath = "sampleinput.txt"
path = "input.txt"

D18P1Solver.new(samplepath).solve
D18P1Solver.new(path).solve
D18P2Solver.new(path).solve
