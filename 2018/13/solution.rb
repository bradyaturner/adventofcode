#!/usr/bin/env ruby

class TrackUnit
  attr_reader :x, :y, :char
  def initialize(x, y, char)
    @x = x
    @y = y
    @char = char
  end
end

class TrackPiece < TrackUnit
  attr_reader :x, :y, :type
  def initialize(x, y, char)
    @type = parse_type char
    super
  end

  def parse_type(type)
    case type
    when '|','-'
      :straight
    when '/','\\'
      :curve
    when '+'
      :intersection
    end
  end

  def to_s
    "TrackPiece #{@type} at (#{@x},#{@y})"
  end
end

class Cart < TrackUnit
  attr_reader :x, :y, :direction
  def initialize(x, y, char)
    @direction = parse_direction char
    @num_turns = 0
    super
  end

  def location
    [@x,@y]
  end

  DIRECTIONS = {
    "<" => [-1,0],
    ">" => [1,0],
    "v" => [0,1],
    "^" => [0,-1]
  }

  def parse_direction(char)
    DIRECTIONS[char]
  end

  def increment_position
    @x += @direction[0]
    @y += @direction[1]
  end

  TURN_DIRECTIONS = [:left, :straight, :right]
  def turn_intersection
    dir = TURN_DIRECTIONS[@num_turns%TURN_DIRECTIONS.length]
    x,y = @direction
    @direction = case dir
    when :left then [y,-x] 
    when :right then [-y,x]
    else @direction
    end
    @num_turns += 1
  end

  def turn_curve(curve_char)
    x,y = @direction
    if curve_char == "\\"
      @direction = [y,x]
    else
      @direction = [y*-1, x*-1]
    end
  end

  def char
    DIRECTIONS.key @direction
  end

  def to_s
    "Cart at (#{@x},#{@y}) facing #{@direction} #{char}"
  end
end

class Day13Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    @pieces = []
    @carts = []
    parse_input
  end

  def run
    loop do
      begin
        iterate
        break if @carts.length <= 1
      rescue => e
        break
      end
    end
  end

  def parse_input
    @height = @file.lines.length
    @width = @file.lines.first.chars.length
    @file.lines.each_with_index do |line,y|
      line.chars.each_with_index do |char,x|
        next if char==" " || char=="\n"
        if ['^', 'v', '<', '>'].include? char
          @carts << Cart.new(x,y,char)
          char = cart_to_track char
        end
        @pieces << TrackPiece.new(x,y,char)
      end
    end
  end

  def cart_to_track(char)
    ['^','v'].include?(char) ? '|' : '-'
  end

  def iterate
    ordered_carts = @carts.sort_by{|c| c.location.reverse}
    ordered_carts.each do |c|
      c.increment_position
      location = track_location c
      if location.type == :intersection
        c.turn_intersection
      elsif location.type == :curve
        c.turn_curve location.char
      end
      handle_crash if check_crash
    end
  end

  def check_crash
    locations = @carts.collect(&:location)
    locations.select{|l| locations.count(l) > 1}.first
  end

  def track_location(cart)
    @pieces.select{|p| p.x==cart.x && p.y==cart.y}.first
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D13P1Solver < Day13Solver
  def handle_crash
    raise
  end

  def solve
    run
    @solution = check_crash.join(',')
    super
  end
end

class D13P2Solver < Day13Solver
  def handle_crash
    location = check_crash
    @carts.reject!{|c| c.location == location}
  end

  def solve
    run
    @solution = @carts.first.location.join(',')
    super
  end
end

samplepath = "sampleinput.txt"
samplepath2 = "sampleinput2.txt"
path = "input.txt"

D13P1Solver.new(samplepath).solve
D13P1Solver.new(path).solve
D13P2Solver.new(samplepath2).solve
D13P2Solver.new(path).solve
