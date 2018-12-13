#!/usr/bin/env ruby

class Player
  attr_accessor :score
  def initialize(id)
    @id = id
    @score = 0
  end
end

class Marble
  attr_reader :id
  attr_accessor :prev, :next
  def initialize(id)
    @id = id
    @prev = nil
    @next = nil
  end
end

class MarbleList
  def initialize
    @head = nil
  end

  def insert(marble)
    if @head.nil?
      marble.next = marble
      marble.prev = marble
    else
      marble.next = @head.next
      @head.next.prev = marble
      @head.next = marble
      marble.prev = @head
    end
    @head = marble
  end

  def delete
    @head.next.prev = @head.prev
    @head.prev.next = @head.next
    temp = @head
    @head = @head.next
    temp
  end

  def right(num)
    num.times {|i| @head = @head.next}
  end

  def left(num)
    num.times {|i| @head = @head.prev}
  end
end

class Day09Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    setup
  end

  def setup
    parts = @file.split
    @num_players = parts[0].to_i
    @players = Hash.new{|hash,key| hash[key] = Player.new(key)}
    @num_rounds = parts[6].to_i
    @marble_list = MarbleList.new
  end

  def play(num_rounds=@num_rounds)
    @marble_list.insert(Marble.new(0))
    1.upto(num_rounds) do |round_num|
      current_player = @players[(round_num % @num_players)]
      if round_num % 23 == 0
        @marble_list.left(7)
        current_player.score += round_num + (@marble_list.delete).id
      else
        @marble_list.right(1)
        @marble_list.insert(Marble.new(round_num))
      end
    end
    @solution = @players.values.map(&:score).max
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D09P1Solver < Day09Solver
  def solve
    play
    super
  end
end

class D09P2Solver < Day09Solver
  def solve
    play(100*@num_rounds)
    super
  end
end

samplepath = "sampleinput.txt"
path = "input.txt"

D09P1Solver.new(samplepath).solve
D09P1Solver.new(path).solve
D09P2Solver.new(samplepath).solve
D09P2Solver.new(path).solve
