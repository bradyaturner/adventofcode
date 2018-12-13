#!/usr/bin/env ruby

class Day08Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    @id = 0
    @nodes = {}
    parse_input
  end

  def parse_input
    @nodes = {}
    data = @file.split.map(&:to_i)
    parse_recursive(data, nil, 1)
  end

  def parse_recursive(data, parent_id, child_count)
    0.upto(child_count-1) do |i|
      num_children, num_metadata = data.shift(2)
      id = next_id
      n = Node.new(id, num_children, num_metadata)
      @nodes[id] = n
      if (!parent_id.nil?)
        @nodes[parent_id].insert_child n
      end
      if num_children > 0
        data = parse_recursive(data, id, num_children)
      end
      metadata = data.shift(num_metadata)
      @nodes[id].set_metadata metadata
    end
    data
  end

  def next_id
    @id += 1
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class Node
  attr_accessor :num_children, :num_metadata, :parent
  attr_reader :metadata, :id
  def initialize(id, num_children, num_metadata)
    @id = id
    @num_children = num_children
    @num_metadata = num_metadata
    @children = []
    @parent = nil
  end

  def insert_child(child)
    @children << child
  end

  def set_metadata(metadata)
    @metadata = metadata
  end

  def value
    if @children.length == 0
      @metadata.sum
    else
      @metadata.collect{|m| @children[m-1]}.compact.map(&:value).sum
    end
  end
end

class D08P1Solver < Day08Solver
  def solve
    @solution = @nodes.values.map(&:metadata).flatten.sum
    super
  end
end

class D08P2Solver < Day08Solver
  def solve
    @solution = @nodes[1].value
    super
  end
end

samplepath = "sampleinput.txt"
path = "input.txt"

D08P1Solver.new(samplepath).solve
D08P1Solver.new(path).solve
D08P2Solver.new(samplepath).solve
D08P2Solver.new(path).solve
