#!/usr/bin/env ruby

class Unit
  attr_reader :x, :y, :char
  def initialize(x, y, char)
    @x = x
    @y = y
    @char = char
  end

  def reading_pos
    [@y, @x]
  end

  def to_s
    char
  end
end

class Character < Unit
  attr_reader :hp, :ap
  attr_writer :hp
  def initialize(x, y, char)
    @hp = 200
    @ap = 3
    super
  end

  def move(x, y)
    #puts "\tMoving #{self.class} from #{@x},#{@y} to #{x},#{y}"
    @x = x
    @y = y
  end

  def to_s
    "#{self.class} at (#{x},#{y}), HP:#{@hp}"
  end
end

class Elf < Character
  attr_writer :ap
end

class Goblin < Character
end

class Wall < Unit
end

class Floor < Unit
end

class Day15Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    parse_input
  end

  def run
    round = 0
    loop do
      still_going = iterate round
      if !still_going
        #puts "Exiting prematurely!"
        break
      end
      round += 1
      break if get_goblins.length == 0 or get_elves.length==0
    end
    print_map @map
    round
  end

  def parse_input
    @width = @file.lines.first.strip.length
    @height = @file.lines.length
    @units = []
    @map = Array.new(@height){Array.new(@width)}

    @file.lines.each_with_index do |line, y|
      line.strip.chars.each_with_index do |c, x|
        @map[y][x] = char_to_unit(x, y, c)
      end
    end
  end

  def iterate(round)
    ordered_players = get_move_order
    ordered_players.each_with_index do |p,i|
      return false if get_goblins.length == 0 or get_elves.length==0
      next if p.hp <= 0
      in_attack_range = targets_in_range(p)

      if in_attack_range.length > 0
        attack(p)
        next
      else
        move(p)
      end

      in_attack_range = targets_in_range(p)
      attack(p) if in_attack_range.length > 0
    end
    return true
  end

  def attack(p)
    targets = targets_in_range p
    min_hp = targets.collect{|t| t.hp}.min
    t = targets.select{|t| t.hp == min_hp}.sort_by(&:reading_pos).first
    t.hp -= p.ap
    if t.hp <= 0
      @units.delete t
    end
  end

  def targets_in_range(p)
    targets = targets(p)
    targets.select do |t|
      ((p.x-t.x).abs <= 1 && (p.y-t.y).abs ==0) ||
        ((p.x-t.x).abs == 0 && (p.y-t.y).abs <=1)
    end
  end

  def move(p)
    reachable_map = lees_algorithm(p.x, p.y)
    targets = targets(p)
    
    locations = []
    targets.each do |t|
      in_range = get_locations_in_range t.x, t.y
      reachable = get_reachable(in_range, reachable_map)
      locations += reachable
    end

    if locations.length > 0
      # Get distances to reachable locations
      min_distance = locations.collect{|x,y| reachable_map[y][x]}.min
      # Get locations at minimum distance
      locations = locations.select{|x,y| reachable_map[y][x] == min_distance}
      # Get first location in "reading order"
      target = locations.sort_by{|x,y| [y,x]}.first

      # Generate lee map for target
      target_lee_map = lees_algorithm(target[0], target[1])
      # Get adjacent locations to current player
      best_moves = get_locations_in_range(p.x, p.y)
      best_moves = best_moves.select{|x,y| target_lee_map[y][x] == min_distance-1}
      m = best_moves.sort_by{|x,y| [y,x]}.first
      p.move(m[0], m[1])
    end
  end 

  def get_locations_in_range(x, y)
    candidates = [ 
      [x-1, y], # left
      [x+1, y], # right
      [x, y-1], # up
      [x, y+1] # down
    ]
    candidates.select{|x,y| in_range?(x,y)}
  end

  def in_range?(x, y)
    # return false if outside bounds, is wall, is target
    !(@map[y][x].class != Floor ||
      y < 0 || x < 0 || y >= @map.length || x >= @map.first.length ||
      unit_at(x,y)
    )
    # TODO don't include self in check for units at location
  end

  def get_reachable(locations, reachable_map)
    #locations.select{|l| is_reachable?(p.x, p.y, l[0], l[1])}
    locations.select {|x,y| !reachable_map[y][x].nil?}
  end

  def is_reachable?(x1, y1, x2, y2)
    reachable_map = lees_algorithm(x1, y1)
  end

  def get_goblins
    @units.select{|u| u.class == Goblin}
  end

  def get_elves
    @units.select{|u| u.class == Elf}
  end

  def char_to_unit(x, y, c)
    case c
    when "G"
      @units << Goblin.new(x, y, c)
      Floor.new(x, y, '.')
    when "E"
      @units << Elf.new(x, y, c)
      Floor.new(x, y, '.')
    when "."
      Floor.new(x, y, c)
    when "#"
      Wall.new(x, y, c)
    end
  end

  def print_map(map, include_units=true)
    map.each_with_index do |r, y|
      r.each_with_index do |c, x|
        unit = unit_at(x, y)
        print (!unit.nil? && include_units) ? unit.char : c.char
      end
      print "\n"
    end
  end

  def print_lee_map(map)
    map.each do |r|
      r.each do |c|
        print c.nil? ? "x" : c
      end
      print "\n"
    end
  end

  def lees_algorithm(x, y)
    map = Array.new(@height){Array.new(@width)}
    map[y][x] = 0

    map = lee_expand(map, x, y)
  end

  def lee_expand(map, x, y)
    distance = map[y][x]
    if @map[y][x].class != Floor
      map[y][x] = @map[y][x].char
    else
      locations = get_locations_in_range x,y
      locations.each do |x2,y2|
        if (map[y2][x2].nil? || distance+1 < map[y2][x2])
          map[y2][x2] = distance + 1
          map = lee_expand(map, x2, y2)
        end
      end
    end
    map
  end
      

  def unit_at(x, y)
    @units.select{|u| u.x == x && u.y == y}.first
  end

  def get_move_order
    @units.sort_by(&:reading_pos)
  end

  def targets(unit)
    @units.select{|u| u.class != unit.class}
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D15P1Solver < Day15Solver
  def solve
    round = run
    puts @units.sort_by(&:reading_pos)
    hp = @units.map(&:hp).sum
    puts "Sum remaining HP: #{hp}"
    puts "Num rounds: #{round}"
    @solution = round * hp
    super
  end
end

class D15P2Solver < Day15Solver
  def solve
    @num_elves = get_elves.length
    elf_ap = 4
    round = 0
    loop do
      round = run
      num_remaining_elves = get_elves.length
      break if num_remaining_elves == @num_elves 
      parse_input
      elf_ap += 1
      get_elves.each {|e| e.ap = elf_ap}
    end
    puts "No losses with #{elf_ap} AP"
    puts @units.sort_by(&:reading_pos)
    hp = @units.map(&:hp).sum
    puts "Sum remaining HP: #{hp}"
    puts "Num rounds: #{round}"
    @solution = round * hp
    super
  end
end

samplepath = "sampleinput.txt"
reachablesamplepath = "reachablesample.txt"
movementsamplepath = "movementsample.txt"
combatsamplepath = "combatsample6.txt"
path = "input.txt"

#D15P1Solver.new(samplepath).solve
#D15P1Solver.new(movementsamplepath).solve
#D15P1Solver.new(combatsamplepath).solve
#D15P1Solver.new(reachablesamplepath).solve
D15P1Solver.new(path).solve
#D15P2Solver.new(samplepath).solve
D15P2Solver.new(path).solve
