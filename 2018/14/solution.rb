#!/usr/bin/env ruby

class Elf
  attr_accessor :index
  def initialize(index)
    @index = index
  end
end

class Node
  attr_reader :value
  attr_accessor :prev, :next
  def initialize(value)
    @value = value
    @next = nil
    @prev = nil
  end
end

class RecipeList
  attr_reader :elf1, :elf2, :size
  def initialize(first, second)
    @start = first

    @elf1 = first
    @elf1.next = first 
    @elf1.prev = first
    @head = first
    @size = 1

    @elf2 = second
    insert second
  end

  def insert(recipe)
    recipe.prev = @head
    recipe.next = @head.next
    @head.next.prev = recipe
    @head.next = recipe
    @head = recipe
    @size += 1
  end

  def advance_elf1
    (1 + @elf1.value).times { @elf1 = @elf1.next }
  end

  def advance_elf2
    (1 + @elf2.value).times { @elf2 = @elf2.next }
  end

  def get_previous_values(num)
    values = []
    current = @head
    0.upto(num-1) do
      values.unshift @head.value
      @head = @head.prev
    end
    @head = current
    values
  end

  def current_sum
    @elf1.value + @elf2.value
  end

  def advance_elves
    advance_elf1
    advance_elf2
  end
end

class Day14Solver
  NUM_EXTRA_ROUNDS = 10
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    @recipes = []
    setup
  end

  def setup
    @rounds = @file.to_i
    first = Node.new(3)
    second = Node.new(7)
    @recipe_list = RecipeList.new(first, second)
  end

  def run
    loop do
      digits = @recipe_list.current_sum.to_s.chars.map(&:to_i)
      digits.each do |d|
        @recipe_list.insert Node.new(d)
        break if solved?
      end
      break if solved?
      @recipe_list.advance_elves
    end
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D14P1Solver < Day14Solver
  def solved?
    @recipe_list.size >= @rounds + NUM_EXTRA_ROUNDS
  end

  def solve
    run
    @solution = @recipe_list.get_previous_values(10).join
    super
  end
end

class D14P2Solver < Day14Solver
  def solved?
    (@recipe_list.get_previous_values @num_previous_values).join == @input
  end

  def solve
    @input = @file.strip
    @num_previous_values = @input.chars.length
    run
    @solution = @recipe_list.size - @num_previous_values
    super
  end
end

samplepath = "sampleinput.txt"
samplepath2 = "sampleinput2.txt"
samplepath3 = "sampleinput3.txt"
samplepath4 = "sampleinput4.txt"
samplepath5 = "sampleinput5.txt"
path = "input.txt"

D14P1Solver.new(samplepath).solve
D14P1Solver.new(path).solve
D14P2Solver.new(samplepath2).solve
D14P2Solver.new(samplepath3).solve
D14P2Solver.new(samplepath4).solve
D14P2Solver.new(samplepath5).solve
D14P2Solver.new(path).solve
