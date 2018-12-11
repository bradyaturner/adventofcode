#!/usr/bin/env ruby

class Vec2i
  attr_accessor :x, :y
  def initialize(x,y)
    @x = x
    @y = y
  end

  def to_s
    "(#{@x},#{@y})"
  end
end

class Point
  attr_accessor :position, :velocity
  def initialize(pos_x, pos_y, vel_x, vel_y)
    @position = Vec2i.new(pos_x, pos_y)
    @velocity = Vec2i.new(vel_x, vel_y)
  end

  def update(direction=1)
    @position.x += (direction*@velocity.x)
    @position.y += (direction*@velocity.y)
  end

  def reverse
    update(-1)
  end

  def to_s
    "Point: pos:#{@position}, vel:#{@velocity}"
  end
end

class Day10Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    @points = []
    parse_input
  end

  def parse_input
    @file.each_line {|l| @points << parse_line(l)}
  end

  def parse_line(line)
    # TODO cleanup (regex?)
    tmp = line.split('<')
    pos = tmp[1].split('>').first.split(',').map(&:to_i)
    vel = tmp.last.split('>').first.split(',').map(&:to_i)
    Point.new(pos.first, pos.last, vel.first, vel.last)
  end

  def get_bounds
    min_x = @points.min_by{|p| p.position.x}.position.x
    min_y = @points.min_by{|p| p.position.y}.position.y
    max_x = @points.max_by{|p| p.position.x}.position.x
    max_y = @points.max_by{|p| p.position.y}.position.y
    min = Vec2i.new(min_x, min_y)
    max = Vec2i.new(max_x, max_y)
    [min, max]
  end

  def update_state
    @points.each {|p| p.update}
  end

  def reverse_state
    @points.each {|p| p.reverse}
  end

  def iterate
    update_state
    min, max = get_bounds
    diff = max.y - min.y
    @direction = (diff - @previous_diff) # negative means shrinking
    @previous_diff = diff
    if @direction > 0
      reverse_state
      min, max = get_bounds
    end
    [min, max]
  end

  def draw(min, max)
    min.y.upto(max.y) do |row|
      min.x.upto(max.x) do |col|
        point = @points.select{|p| (p.position.y == row) && (p.position.x == col)}.first
        print point ? '#' : '.'
      end
      print "\n"
    end
  end

  def run
    min, max = get_bounds
    num_iterations = 0
    @previous_diff = max.y - min.y + 1
    @direction = 0
    loop do
      min, max = iterate
      if @direction > 0
        draw(min, max)
        break
      end
      num_iterations +=1
    end
    num_iterations
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D10P1Solver < Day10Solver
  def solve
    run
    super
  end
end

class D10P2Solver < Day10Solver
  def solve
    @solution = run
    super
  end
end

samplepath = "sampleinput.txt"
path = "input.txt"

D10P1Solver.new(samplepath).solve
D10P1Solver.new(path).solve
D10P2Solver.new(samplepath).solve
D10P2Solver.new(path).solve
