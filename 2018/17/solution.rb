#!/usr/bin/env ruby

require './vein'

class Day17Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    @source_coords = [500,0]
    parse_input
    create_grid
    #print_grid
  end

  def parse_input
    @veins = []
    @file.lines.each {|l| @veins << parse_vein_desc(l)}
    @bounds = get_bounds
  end

  def get_bounds(include_source=true)
    vein_bounds = @veins.collect{|v| v.bounds}
    x_vals = vein_bounds.collect{|b| [b[0][0],b[1][0]]}.flatten
    y_vals = vein_bounds.collect{|b| [b[0][1],b[1][1]]}.flatten
    if include_source
      x_vals << @source_coords[0]
      y_vals << @source_coords[1]
    end
    [[x_vals.min-2, y_vals.min],[x_vals.max+2,y_vals.max]]
  end

  def parse_vein_desc(desc)
    parts = desc.strip.split(", ")
    parts.map!{|p| p.split("=")}
    parts.each{|p| p[1] = p.last.split("..")}
    Vein.new(parts[0][1].first.to_i, parts[1][1].map(&:to_i), parts[1][0])
  end

  def create_grid
    @x_offset = @bounds[0][0]
    @y_offset = @bounds[0][1]
    width = @bounds[1][0] - @bounds[0][0] + 1
    height = @bounds[1][1] - @bounds[0][1] + 1
    @grid = Array.new(height){Array.new(width){"."}}
    @grid[0-@y_offset][500-@x_offset] = "+"
    @veins.each do |v|
      if v.dim == "x"
        v.range[0].upto(v.range[1]) do |x|
          @grid[v.start-@y_offset][x-@x_offset] = "#"
        end
      else
        v.range[0].upto(v.range[1]) do |y|
          @grid[y-@y_offset][v.start-@x_offset] = "#"
        end
      end
    end
  end

  def run
    expand_down(@source_coords[0], @source_coords[1])
  end

  def get_coord(x,y)
    @grid[y-@y_offset][x-@x_offset]
  end

  def set_coord(x,y,value)
    @grid[y-@y_offset][x-@x_offset] = value
  end

  def check_bounds(x,y)
    (x > @bounds[1][0]) ||
      (x < @bounds[0][0]) ||
      (y > @bounds[1][1]) ||
      (y < @bounds[0][1])
  end

  def is_types(x, y, types)
    c = get_coord(x,y)
    (c == "." && types.include?(:sand)) ||
      (c == "#" && types.include?(:clay)) ||
      (c == "|" && types.include?(:falling_water)) ||
      (c == "~" && types.include?(:water)) ||
      (c == "+" && types.include?(:source))
  end

  def expand_down(x, y)
    y += 1
    return true if check_bounds(x,y)
    if is_types(x,y,[:sand,:water,:falling_water])
      if is_types(x,y,[:falling_water,:sand])
        set_coord(x,y,"|")
      end
      return true if check_bounds(x,y+1)
      if is_types(x,y+1,[:clay])
        overflow_left = expand_left(x,y)
        overflow_right = expand_right(x,y)
        if (!overflow_left && !overflow_right)
          fill_row(x,y)
          set_coord(x,y,"~")
          expand_up(x,y)
        end
      else
        expand_down(x,y)
      end
    end
  end

  def expand_up(x, y)
    y -= 1
    if is_types(x,y,[:sand,:falling_water,:water])
      if is_types(x,y,[:sand,:falling_water])
        set_coord(x,y,"|")
      end
      overflow_left = expand_left(x,y)
      overflow_right = expand_right(x,y)
      if (!overflow_left && !overflow_right)
        fill_row(x,y)
        set_coord(x,y,"~")
        expand_up(x,y)
      end
    end
  end

  def fill_row(x,y)
    fill_left(x,y)
    fill_right(x,y)
  end

  def fill_horizontal(x,y,direction)
    x += direction
    if is_types(x,y,[:falling_water])
      set_coord(x,y,"~")
      fill_horizontal(x,y,direction)
    end
  end

  def fill_left(x,y)
    fill_horizontal(x,y,1)
  end

  def fill_right(x,y)
    fill_horizontal(x,y,-1)
  end

  def expand_right(x,y)
    expand_horizontal(x,y,1)
  end

  def expand_left(x,y)
    expand_horizontal(x,y,-1)
  end

  def expand_horizontal(x, y, direction)
    x+=direction
    if is_types(x,y,[:sand,:falling_water,:water])
      set_coord(x,y,"|")
      if is_types(x,y+1,[:clay,:water])
        overflow = expand_horizontal(x,y,direction)
        return overflow
      else
        if !is_types(x,y+1,[:falling_water])
          expand_down(x,y)
          if is_types(x,y+1,[:water])
            return false
          end
        end
        return true
      end
    end
    return false
  end

  def print_grid
    @grid.each do |r|
      r.each {|c| print c}
      print "\n"
    end
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D17P1Solver < Day17Solver
  def solve
    run
    y_min = get_bounds(false)[0][1]
    count = @grid[y_min..-1].flatten.count{|g| g.match(/~|\|/)}
    @solution = count
    super
  end
end

class D17P2Solver < Day17Solver
  def solve
    run
    #print_grid
    y_min = get_bounds(false)[0][1]
    count = @grid[y_min..-1].flatten.count{|g| g.match(/~/)}
    @solution = count
    super
  end
end

samplepath = "sampleinput.txt"
path = "input.txt"

D17P1Solver.new(samplepath).solve
D17P1Solver.new(path).solve
D17P2Solver.new(samplepath).solve
D17P2Solver.new(path).solve
