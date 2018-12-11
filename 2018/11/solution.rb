#!/usr/bin/env ruby

class Cell
  attr_reader :x, :y, :power
  attr_accessor :grid_power
  def initialize(x, y, power)
    @x = x
    @y = y
    @power = power
    @grid_power = 0
  end

  def to_s
    "Cell at (#{@x}, #{@y}), Power=#{@power}, Grid Power=#{@grid_power}"
  end
end

class Day11Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    setup
  end

  WIDTH = 300
  HEIGHT = 300
  def setup
    @serial = @file.strip.to_i
    @grid = Array.new(HEIGHT){Array.new(WIDTH)}
    populate_grid
    calculate_powers
    best = @grid.flatten.max_by{|c| c.grid_power}
    puts best
    @solution = "#{best.x},#{best.y}"
  end

  def populate_grid
    @grid.each_with_index do |row, y| # y
      row.each_with_index do |val, x| # x
        @grid[y][x] = Cell.new(x+1, y+1, power_level(x+1, y+1))
      end
    end
  end

  def calculate_powers
    0.upto(HEIGHT-3) do |y|
      0.upto(WIDTH-3) do |x|
        @grid[y][x].grid_power = calculate_grid_power(x, y)
      end
    end
  end

  def calculate_grid_power(x, y)
    sum = 0
    y.upto(y+2) do |y2|
      x.upto(x+2) do |x2|
        sum += @grid[y2][x2].power
      end
    end
    sum
  end

  def power_level(x, y, serial=@serial)
    rack_id = x + 10
    power_level = rack_id * y
    power_level += serial
    power_level *= rack_id
    power_level = power_level.to_s.chars.reverse[2].to_i
    power_level -= 5
    power_level
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D11P1Solver < Day11Solver
  def solve
    super
  end
end

class D11P2Solver < Day11Solver
  def solve
    super
  end
end

samplepath = "sampleinput.txt"
path = "input.txt"

D11P1Solver.new(samplepath).solve
D11P1Solver.new(path).solve
#D11P2Solver.new(samplepath).solve
#D11P2Solver.new(path).solve
