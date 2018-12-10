#!/usr/bin/env ruby

class Day08Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    @id = 0
  end

  def parse_input
    # TODO just call parse_recursive here
    @nodes = {}
    data = @file.split.map(&:to_i)
    num_children, num_metadata = data.shift(2)
    id = next_id
    @nodes[id] = Node.new(id, num_children, num_metadata)
    parse_recursive(data, id, num_children)
    metadata = data.shift(num_metadata)
    @nodes[id].set_metadata metadata
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
    value = 0
    if @children.length == 0
      value = @metadata.inject(&:+)
    else
      @metadata.each do |m|
        c = @children[m-1]
        if !c.nil?
          value += c.value
        end
      end
    end
    value
  end
end

class D08P1Solver < Day08Solver
  def solve
    parse_input
    @sum = 0
    @nodes.each {|id, n| @sum += n.metadata.inject(&:+)}
    @solution = @sum
    super
  end
end

class D08P2Solver < Day08Solver
  def solve
    parse_input
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
