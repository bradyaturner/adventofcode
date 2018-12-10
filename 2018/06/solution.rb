#!/usr/bin/env ruby

class Coord
  attr_reader :x, :y
  attr_accessor :id, :area, :infinite, :dist
  def initialize(x, y, id=nil)
    @id = id
    @x = x
    @y = y
    @area = 1
    @infinite = false
    @dist = 0
  end

  def to_s
    "ID: #{@id}: (#{@x}, #{@y}) Area: #{@area}, Dist: #{@dist}, Infinite: #{@infinite}"
  end
end

class Location < Coord
end

class Day06Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    setup
  end

  def setup
    parse_coords
    @max_x, @max_y = find_max_coords
    initialize_grid(@max_x+1, @max_y+1)
    populate_grid
  end

  def parse_coords
    @coords = []
    @file.lines.each_with_index do |line,id|
      row,col = line.strip.split(',')
      @coords << Location.new(col.to_i, row.to_i, id+1)
    end
  end

  def initialize_grid(w,h)
    @grid = Array.new(w){Array.new(h)}
  end

  def populate_grid
    @coords.each {|c| @grid[c.x][c.y] = c}
    @grid.each_with_index do |col,x|
      col.each_with_index do |row,y|
        next if @grid[x][y].instance_of? Location
        @grid[x][y] = Coord.new(x, y)
      end
    end
  end

  def print_grid
    @grid.each do |col|
      col.each {|c| printf "%3s", (!c ? "." : c.id)}
      print "\n"
    end
  end

  def find_max_coords
    x = @coords.sort_by{|c| c.x}.last.x
    y = @coords.sort_by{|c| c.y}.last.y
    [x,y]
  end

  def manhattan_distance(x1, y1, x2, y2)
    (x1-x2).abs + (y1-y2).abs
  end

  def find_closest(x,y)
    min_coords = []
    min_distance = nil
    @coords.each do |c|
      dist = manhattan_distance(x, y, c.x, c.y)
      if !min_distance || (dist < min_distance)
        min_distance = dist
        min_coords = [c]
      elsif dist == min_distance
        min_coords << c
      end
    end
    min_coords
  end

  def calculate_distances
    @grid.flatten.each do |c|
      next if c.instance_of? Location
      coords = find_closest(c.x,c.y)
      c.id = (coords.length == 1) ? (-1*coords.first.id) : '.'
    end
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D06P1Solver < Day06Solver
  def parse_distances
    @grid.flatten.each do |coord|
      next if (coord.instance_of? Location) || (coord.id == '.')
      closest_coord = @coords.select{|c| -1*c.id == coord.id}.first
      closest_coord.area += 1
      if (coord.x == 0) || (coord.y == 0) || (coord.x == @max_x) || (coord.y == @max_y)
        closest_coord.infinite = true
      end
    end
  end

  def solve
    calculate_distances
    parse_distances
    @solution = @coords.select {|c| !c.infinite}.sort_by{|c| c.area}.last.area
    super
  end
end

class D06P2Solver < Day06Solver
  def calculate_total_distances(coord)
    @coords.each do |c|
      coord.dist += manhattan_distance(coord.x, coord.y, c.x, c.y)
    end
  end

  def solve(dist)
    @grid.flatten.each {|c| calculate_total_distances(c)}
    @solution = @grid.flatten.select{|c| c.dist < dist}.length
    super()
  end
end

samplepath = "sampleinput.txt"
path = "input.txt"

D06P1Solver.new(samplepath).solve
D06P1Solver.new(path).solve
D06P2Solver.new(samplepath).solve(32)
D06P2Solver.new(path).solve(10000)
