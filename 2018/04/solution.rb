#!/usr/bin/env ruby

require 'date'

class Record
  attr_reader :time, :event
  def initialize(timestr, event)
    @time = DateTime.parse(timestr,"%Y-%m-%d %H:%M")
    @event = event
  end

  def <=>(r2)
    @time<=>r2.time
  end

  def to_s
    "#{@time.strftime("%Y-%m-%d %H:%M")} : #{@event}"
  end
end

class Guard
  attr_reader :id, :minutes_asleep
  def initialize(id)
    @id = id
    @minutes_asleep = Array.new(60){0}
  end

  def fall_asleep(time)
    @asleep_time = time
  end

  def wake_up(time)
    raise if @asleep_time == nil
    @asleep_time.minute.upto(time.minute-1) do |m|
      @minutes_asleep[m] += 1
    end
    @asleep_time = nil
  end

  def total_asleep_minutes
    @minutes_asleep.inject(&:+)
  end

  def most_asleep_minute
    @minutes_asleep.index(@minutes_asleep.max)
  end
end

class Day04Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    parse_record_file
    analyze_logs
  end

  def parse_record_file
    @records = []
    @file.lines.each do |l|
      parts = l.tr('[','').split("]")
      @records << Record.new(parts.first, parts.last)
    end
    @records.sort!
  end

  def analyze_logs
    current_guard_id = nil
    @guards = {}
    @records.each do |r|
      if r.event.include? "begins"
        current_guard_id = begin_shift r
      elsif r.event.include? "falls"
        @guards[current_guard_id].fall_asleep(r.time)
      elsif r.event.include? "wakes"
        @guards[current_guard_id].wake_up(r.time)
      else
        raise "Unrecognized event!"
      end
    end
  end

  def begin_shift(r)
    id = r.event.tr('#','').split[1]
    if !@guards[id]
      @guards[id] = Guard.new(id)
    end
    id
  end

  def solve
    @solution = @guard.id.to_i * @guard.most_asleep_minute
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D04P1Solver < Day04Solver
  def solve
    @guard = @guards.max_by {|id,g| g.total_asleep_minutes}.last
    super
  end
end

class D04P2Solver < Day04Solver
  def solve
    @guard = @guards.max_by {|id,g| g.minutes_asleep[g.most_asleep_minute]}.last
    super
  end
end

samplepath = "sampleinput.txt"
path = "input.txt"

D04P1Solver.new(samplepath).solve
D04P1Solver.new(path).solve
D04P2Solver.new(samplepath).solve
D04P2Solver.new(path).solve
