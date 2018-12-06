#!/usr/bin/env ruby

class Day05Solver
  ASCII_OFFSET = 32
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @units = @file.tr("\n",'').chars
    @solution = nil
  end

  def compare_chars(a,b)
    (a.ord - b.ord).abs == ASCII_OFFSET
  end

  def react(poly)
    loop do
      modified = false
      poly.each_with_index do |u,i|
        break if poly[i+1] == nil
        if (compare_chars(u,poly[i+1]))
          poly.delete_at(i)
          poly.delete_at(i)
          modified = true
        end
      end
      break if !modified
    end
    poly
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D05P1Solver < Day05Solver
  def solve
    @solution = react(@units).length
    super
  end
end

class D05P2Solver < Day05Solver
  def solve
    poly_lengths = {}
    ('a'..'z').each do |c|
      tmp = Array.new(@units)
      tmp.delete(c)
      tmp.delete(c.upcase)
      poly = react(tmp)
      poly_lengths[c] = poly.length
    end

    @solution= poly_lengths.sort_by{|p,v| v}.first.last
    super
  end
end

samplepath = "sampleinput.txt"
path = "input.txt"

D05P1Solver.new(samplepath).solve
D05P1Solver.new(path).solve
D05P2Solver.new(samplepath).solve
D05P2Solver.new(path).solve
