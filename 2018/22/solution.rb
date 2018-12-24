#!/usr/bin/env ruby

require './grid'

class Region < Vec2i
  attr_accessor :erosion_level, :geologic_index
  def initialize(x, y)
    @erosion_level = nil
    @geologic_index = nil
    super
  end

  TYPES = [:rocky, :wet, :narrow]
  def type
    TYPES[@erosion_level % 3]
  end

  TYPE_CHARS = {:rocky => '.', :wet => '=', :narrow => '|'}
  def type_char
    TYPE_CHARS[type]
  end

  def type_id
    TYPES.index type
  end

  def ==(region)
    x == region.x && y == region.y
  end
end

class Day22Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    parse_input
    populate_grid
  end

  def parse_input
    lines = @file.lines.map(&:strip)
    @depth = lines.first.split(": ").last.to_i
    tc = lines.last.split(": ").last.split(",").map(&:to_i)
    @target = Region.new(tc[0], tc[1])
    @grid = Grid.new(@target.x+1, @target.y+1)
    @mouth = Region.new(0,0)
    @grid.set_value_at(@mouth, @mouth)
    @grid.set_value_at(@target, @target)
  end

  def populate_grid
    @grid.each_coord do |coord, val|
      if val.nil?
        val = Region.new(coord.x, coord.y)
        @grid.set_value_at(val, val)
      end
      val.geologic_index = geologic_index val
      val.erosion_level = erosion_level val
    end
  end

  EL_MOD = 20183
  def erosion_level(region)
    (geologic_index(region) + @depth) % EL_MOD
  end

  def geologic_index(region)
    if region.geologic_index
      region.geologic_index
    elsif region == @mouth
      0
    elsif region == @target
      0
    elsif region.y == 0
      region.x * 16807
    elsif region.x == 0
      region.y * 48271
    else
      @grid.value_at(Vec2i.new(region.x-1, region.y)).erosion_level *
        @grid.value_at(Vec2i.new(region.x, region.y-1)).erosion_level
    end
  end

  def print_grid
    @grid.each_coord do |coord, val|
      if val == @mouth
        print 'M'
      elsif val == @target
        print 'T'
      else
        print val.type_char 
      end
      print "\n" if coord.x == @grid.width-1
    end
  end

  def risk_level
    risk = 0
    @grid.each_coord do |coord, val|
      risk += val.type_id
    end
    risk
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D22P1Solver < Day22Solver
  def solve
    @solution = risk_level
    super
  end
end

class D22P2Solver < Day22Solver
  def solve
    super
  end
end

samplepath = "sampleinput.txt"
path = "input.txt"

D22P1Solver.new(samplepath).solve
D22P1Solver.new(path).solve
#D22P2Solver.new(samplepath).solve
#D22P2Solver.new(path).solve
