#!/usr/bin/env ruby

class Day02Solver
  def initialize(path)
    @file = File.read path
    @lines = @file.split
    @filename = File.basename path
    @solution = nil
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end


class D02P1Solver < Day02Solver
  LETTERS = "abcdefghijklmnopqrstuvwxyz".chars
  NUMBERS = [2, 3]
  def solve
    count = Hash.new(0)
    @lines.each do |l|
      contain_two = false
      contain_three = false
      line_count = Hash.new(false)
      LETTERS.each do |c|
        NUMBERS.each do |n|
        if !line_count[n] && l.count(c) == n
          count[n] += 1
          line_count[n] = true
        end
      end
     end
    end
    @solution = count[2] * count[3]
    super
  end
end

class D02P2Solver < Day02Solver
  def solve
    @lines.each do |l|
      @lines.each do |l2|
        inequal_indices = []
        l2.chars.each_with_index do |c,ci|
          inequal_indices << ci if c != l[ci]
          break if inequal_indices.length > 1
        end
        if inequal_indices.length == 1
          difference = l
          difference.slice!(inequal_indices.first)
          @solution = difference
          break
        end
      end
      break if @solution
    end
    super
  end
end

samplepath = "sampleinput.txt"
samplepath2 = "sampleinput2.txt"
path = "input.txt"

D02P1Solver.new(samplepath).solve
D02P1Solver.new(path).solve
D02P2Solver.new(samplepath2).solve
D02P2Solver.new(path).solve
