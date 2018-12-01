#!/usr/bin/env ruby

def create_template(day)

template = %{#!/usr/bin/env ruby

class Day#{day}Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
  end

  def solve
    puts "\#{self.class} (\#{@filename}): \#{@solution}"
  end
end

class D#{day}P1Solver < Day#{day}Solver
  def solve
    super
  end
end

class D#{day}P2Solver < Day#{day}Solver
  def solve
    super
  end
end

samplepath = "sampleinput.txt"
path = "input.txt"

D#{day}P1Solver.new(samplepath).solve
D#{day}P1Solver.new(path).solve
D#{day}P2Solver.new(samplepath).solve
D#{day}P2Solver.new(path).solve
}
end

if __FILE__==$0
  puts create_template("1")
end
