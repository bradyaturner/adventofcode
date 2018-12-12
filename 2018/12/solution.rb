#!/usr/bin/env ruby

OFFSET = 5000
WIDTH = 5

class Rule
  attr_reader :condition, :value
  def initialize(condition, value)
    @condition = condition
    @value = value
  end
end

class Day12Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    parse_input
  end

  def parse_input
    lines = @file.lines.map(&:strip)
    @initial_state = lines.shift.split(": ").last

    @pots = Array.new(2* OFFSET + @initial_state.chars.length){'.'}
    @initial_state.chars.each_with_index do |c,i|
      @pots[OFFSET+i] = c
    end
    @rules = []
    lines.shift
    lines.each do |l|
      parts = l.split
      @rules << Rule.new(parts.first, parts.last)
    end
  end

  def get_adjacent(center)
    first = center - (WIDTH/2)
    last = (center + (WIDTH/2))
    @pots[first..last]
  end

  def iterate(iteration)
    new_pots = Array.new(@pots)
    @pots.each_with_index do |p,i|
      check_bounds(p,i)
      adjacent = get_adjacent(i).join
      match = @rules.select{|r| r.condition==adjacent}.first
      new_pots[i] = match ? match.value : "."
    end
    @pots = new_pots
    @pots.select{|p| p=="#"}.length
  end

  def check_bounds(value, index)
    if ((index <= WIDTH/2) ||
        (index >= (@pots.length-1-WIDTH/2))) &&
      (value == "#")
      raise "Value too close to edge: value: #{value} at index: #{index}"
    end
  end

  def pot_index_sum
    sum = 0
    @pots.each_with_index do |p,i|
      sum += (i-OFFSET) if p=="#"
    end
    sum
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D12P1Solver < Day12Solver
  def solve
    @num_iterations = 20
    @num_iterations.times {|i| iterate i}
    @solution = pot_index_sum 
    super
  end
end

class D12P2Solver < Day12Solver
  def iterate_until_stable
    previous_sums = []
    i = 0
    loop do
      previous_sums << iterate(i)
      if previous_sums.length > 10
        break if previous_sums[-10..-1].uniq.length == 1
      end
      i += 1
    end
    pot_index_sum + (@num_iterations-i-1)*previous_sums.last
  end

  def solve(iterations)
    @num_iterations = iterations
    @solution = iterate_until_stable
    super()
  end
end

samplepath = "sampleinput.txt"
path = "input.txt"

D12P1Solver.new(samplepath).solve
D12P1Solver.new(path).solve
D12P2Solver.new(path).solve(50000000000)
