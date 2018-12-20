#!/usr/bin/env ruby

require 'logger'
require './grid'

class Day20Solver
  FLOOR = '.'
  HDOOR = '-'
  VDOOR = '|'
  UNKNOWN = '?'
  OCCUPIED = 'X'
  WALL = '#'

  def initialize(path, initial_size=5)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    @grid = Grid.new(initial_size, initial_size, UNKNOWN)
    @start_location = Vec2i.new(initial_size/2, initial_size/2)
    @logger = Logger.new(STDERR)
    @logger.level = Logger::INFO
    parse_input
  end

  def parse_input
    @file.strip!
    @logger.debug "Input: #{@file}"
    @cp = Vec2i.new(@start_location.x, @start_location.y)
    @grid.set_value_at(@cp, FLOOR)
    create_corner_walls(@cp)
    branch(@cp, @file.chars[1..-2])
  end

  DIRECTIONS = {
    "W" => Vec2i.new(-1,0),
    "E" => Vec2i.new(1,0),
    "N" => Vec2i.new(0,-1),
    "S" => Vec2i.new(0,1)
  }

  def branch(coord, directions)
    start = Vec2i.new(coord.x, coord.y)
    loop do
      dir = directions.shift
      case dir
      when "E","W","N","S"
        move DIRECTIONS[dir]
      when "|"
        @cp.set(start)
      when "("
        coord.set @cp
        branch(coord,directions)
        @cp.set coord
      when ")"
        return
      end
      break if directions.length == 0
    end
  end

  CORNERS = {
    :upper_left => Vec2i.new(-1,-1),
    :upper_right => Vec2i.new(1,-1),
    :lower_left => Vec2i.new(-1,1),
    :lower_right => Vec2i.new(1,1)
  }

  def create_corner_walls(location)
    CORNERS.each {|name,vec| @grid.set_value_at(location+vec, WALL)}
  end

  def fill_walls
    @grid.each_coord {|vec,val| c = (val==UNKNOWN ? WALL : val)}
  end

  def move(direction)
    @logger.debug "Move: from:#{@cp} direction: #{direction}"
    overflow = @grid.out_of_bounds?(direction*3 + @cp) # 3x direction to include new walls
    grow_grid if overflow
    door_type = (direction.x != 0) ? VDOOR : HDOOR
    @grid.set_value_at(@cp+direction, door_type)
    @cp += direction*2
    @grid.set_value_at(@cp, FLOOR)
    create_corner_walls(@cp)
  end

  def grow_grid
    @logger.debug "Grow Grid: #{@width}x#{@height}"
    offset = @grid.grow
    @start_location += offset
    @cp += offset
  end

  def calculate_distances
    lees_algo @start_location
  end

  def lees_algo(location)
    grid = Grid.new(@grid.width,@grid.height)
    @grid.each_coord do |coord, val|
      grid.set_value_at(coord, val) if val != FLOOR
    end

    grid.set_value_at(location, 0)
    lee_expand(grid,[location])
    grid
  end

  def lee_expand(grid, locations)
    loop do
      location = locations.pop
      distance = grid.value_at location
      @logger.debug "Lee expand at #{location}, distance=#{distance}"
      if @grid.value_at(location) == FLOOR
        DIRECTIONS.each do |dir, mag|
          barrier = @grid.value_at location+mag
          if barrier == VDOOR or barrier == HDOOR
            next_location = (mag * 2) + location
            next_distance = distance + 1
            next_value = grid.value_at next_location
            if next_value.nil? || next_value > next_distance
              grid.set_value_at(next_location, next_distance)
              locations.push next_location
            end
          end
        end
      end
    break if locations.length == 0
    end
  end

  def print_grid
    @grid.each_coord do |coord, val|
      print (coord.x == @start_location.x && coord.y == @start_location.y) ? OCCUPIED : val
      print "\n" if coord.x == @grid.width-1
    end
  end

  def distances(map)
    map.values.grep(Numeric)
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D20P1Solver < Day20Solver
  def solve
    fill_walls
    map = calculate_distances
    @solution = distances(map).max
    super
  end
end

class D20P2Solver < Day20Solver
  def solve
    fill_walls
    map = calculate_distances
    @solution = distances(map).select{|d| d>=1000}.length
    super
  end
end

samplepath = "sampleinput.txt"
samplepath2 = "sampleinput2.txt"
samplepath3 = "sampleinput3.txt"
samplepath4 = "sampleinput4.txt"
path = "input.txt"

D20P1Solver.new(samplepath).solve
D20P1Solver.new(samplepath2).solve
D20P1Solver.new(samplepath3).solve
D20P1Solver.new(samplepath4).solve
D20P1Solver.new(path).solve
D20P2Solver.new(samplepath).solve
D20P2Solver.new(path).solve
