class Vein
  attr_reader :start, :range, :dim
  def initialize(start, range, dim)
    @start = start
    @range = range
    @dim = dim
    if dim == "y"
      @start_coord = [start, range[0]]
      @end_coord = [start, range[1]]
    else
      @start_coord = [range[0], start]
      @end_coord = [range[1], start]
    end
  end

  def bounds
    [@start_coord, @end_coord]
  end

  def to_s
    "#{self.class} in #{@dim}-dimension, from #{@start_coord.inspect} to #{@end_coord.inspect}"
  end
end
