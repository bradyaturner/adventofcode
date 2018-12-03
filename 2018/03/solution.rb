#!/usr/bin/env ruby

class Claim
  attr_reader :id, :x, :y, :w, :h
  def initialize(id, x, y, w, h)
    @id = id
    @x = x.to_i
    @y = y.to_i
    @w = w.to_i
    @h = h.to_i
  end

  def to_s
    "[#{@id}] (#{@x},#{@y}) #{@w}x#{@h}"
  end
end

class Day03Solver
  GRID_SIZE = 1000
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    setup
  end

  def setup
    @claims = []
    @file.lines.each do |l|
      parse_claim l
    end

    @grid = Array.new(GRID_SIZE){Array.new(GRID_SIZE){0}}
    @over_two = 0

    each_claim_square do |c,x,y|
      @grid[x][y] += 1
      if @grid[x][y] == 2
        @over_two += 1
      end
    end
  end

  def each_claim_square
    @claims.each do |c|
      c.x.upto(c.x + c.w-1) do |x|
        c.y.upto(c.y + c.h-1) do |y|
          yield c,x,y
        end
      end
    end
  end

  def parse_claim(line)
    parts = line.split
    id = parts.first.tr('#','')
    coords = parts[2].tr(':','').split(",")
    dims = parts[3].split("x")
    @claims << Claim.new(id, coords.first, coords.last, dims.first, dims.last)
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D03P1Solver < Day03Solver
  def solve
    @solution = @over_two
    super
  end
end

class D03P2Solver < Day03Solver
  def solve
    ids = @claims.collect{|c| c.id}
    each_claim_square do |c,x,y|
      if @grid[x][y] >= 2
        ids.delete c.id
      end
    end
    @solution = ids.first
    super
  end
end

samplepath = "sampleinput.txt"
path = "input.txt"

D03P1Solver.new(samplepath).solve
D03P1Solver.new(path).solve
D03P2Solver.new(samplepath).solve
D03P2Solver.new(path).solve
