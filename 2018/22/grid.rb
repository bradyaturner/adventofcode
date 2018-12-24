class Vec2i
  attr_accessor :x, :y
  def initialize(x,y)
    set_xy x,y
  end

  def set(vec)
    set_xy vec.x, vec.y
  end

  def set_xy(x,y)
    @x = x
    @y = y
  end

  def to_s
    "#{self.class}: (#{@x},#{@y})"
  end

  def +(vec)
    Vec2i.new(@x+vec.x, @y+vec.y)
  end

  def *(val)
    Vec2i.new(@x*val, @y*val)
  end
end

class Grid
  attr_reader :width, :height
  def initialize(width, height, initial_value=nil)
    @width = width
    @height = height
    @initial_value = initial_value
    @grid = Array.new(@height){Array.new(@width){@initial_value}}
  end

  def value_at(vec)
    grid_value_at(@grid, vec)
  end

  def grid_value_at(grid, vec)
    grid[vec.y][vec.x]
  end

  def set_value_at(vec, value)
    set_grid_value_at(@grid, vec, value)
  end

  def set_grid_value_at(grid, vec, value)
    grid[vec.y][vec.x] = value
  end

  def each_coord
    @grid.each_with_index do |row, y|
      row.each_with_index do |val, x|
        yield Vec2i.new(x,y), val
      end
    end
  end

  def values
    @grid.flatten
  end

  def grow(factor=2)
    # TODO grow x/y independently?
    @width *= 2
    @height *= 2
    offset = Vec2i.new(@width/3, @height/3)
    grid = Array.new(@height){Array.new(@width){@initial_value}}
    each_coord {|coord, val| set_grid_value_at(grid, coord + offset, val)}
    @grid = grid
    offset
  end

  def out_of_bounds?(coord)
    coord.x < 0 || coord.x >= @width || coord.y < 0 || coord.y >= @height
  end
end
