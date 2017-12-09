#!/usr/bin/env ruby

GROUP_START = '{'
GROUP_END = '}'

GARBAGE_START = '<'
GARBAGE_END = '>'

CANCEL = '!'

class DayNineSolver
  def initialize(path)
    @path = path
    @file = File.read @path # picks up ending newline char -- does this matter?
    @score = 0
  end

  def solve
    #puts @file.inspect
    parse(0,@file.length-1)
    puts "Solution: #{@score}"
  end

  # parse a substring -- return its score
  def parse(si,ei,ds=0)
    puts "Parse(#{si},#{ei}): First: #{@file[si]}, Last: #{@file[ei]}"
    i = si
    sc = nil
    ec = nil
    gs = nil
    ge = nil
    depth = 0
    garbage = false
    cancel = false
    @file[si..ei].each_char do |c|
      # garbage has no depth -- < has no special meaning within garbage
      if c == GARBAGE_START && !cancel && !garbage
        garbage = true
        gs = i if !gs
      elsif c == GARBAGE_END && !cancel && garbage
        garbage = false
        ge = i if !ge
      end

      if c == GROUP_START && !garbage # ignore groups nested in garbage
        depth += 1
        sc = i if !sc
      elsif c == GROUP_END && !garbage #ignore groups nested in garbage
        depth -= 1
        ec = i if !ec && depth == 0
      end

      if sc && ec
        puts "FOUND GROUP: SC: #{sc}, EC: #{ec}, Score: #{ds+1}"
        @score += ds+1
        parse(sc+1,ec-1,ds+1)
        sc = nil
        ec = nil
      end

      if gs && ge
        puts "FOUND GARBAGE: GS: #{gs}, GE: #{ge}"
        gs=nil
        ge=nil
      end

      # if we're in garbage, its a cancel character, and not cancelled by a preceding cancel
      cancel = garbage && c==CANCEL && !cancel

      i += 1
    end
  end
end

class D9P1Solver < DayNineSolver
end

path = "input.txt"
D9P1Solver.new(path).solve
