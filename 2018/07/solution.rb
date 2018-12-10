#!/usr/bin/env ruby

class Step
  attr_reader :id, :prereqs
  attr_accessor :in_progress
  def initialize(id)
    @id = id
    @in_progress = false
    @prereqs = []
  end

  def add_prereq(p)
    @prereqs << p
  end

  def remove_prereq(p)
    @prereqs.delete p
  end
end

class Worker
  attr_reader :step, :time
  def initialize
    @step = nil
    @time = 0
  end

  def start_step(id, time)
    @step = id
    @time = time
  end

  def free?
    @time == 0
  end

  def update
    @time -= 1
    ret = nil
    if @time == 0
      ret = @step
      @step = nil
    end
    ret
  end
end

class Day07Solver
  def initialize(path)
    @file = File.read path
    @filename = File.basename path
    @solution = nil
    parse_instructions
  end

  def parse_instructions
    @steps = {}
    @file.each_line do |l|
      prereq, id = parse_step l
      @steps[id] = Step.new(id) if !@steps[id]
      @steps[id].add_prereq prereq
    end
  end

  def parse_step(s)
    parts = s.split
    [parts[1], parts[7]]
  end

  def process_steps
    @workers = Array.new(@num_workers) {Worker.new}
    @executed_steps = []
    @time = 0
    steps = [get_first_step] #can there ever be >1 first step?
    loop do
      break if @steps.keys.length == 0
      begin_steps(steps) if steps.length > 0
      update_steps
      steps = get_next_steps
      @time += 1
    end
  end

  def execute_step(step)
    @executed_steps << step
    @steps.each {|id,s| s.remove_prereq(step)}
    @steps.delete step
  end

  def get_next_steps
    step = @steps.select{|id,s| (s.prereqs.length==0) && (!s.in_progress)}.keys.sort
  end

  def begin_steps(steps)
    free_workers = @workers.select {|w| w.free?}
    free_workers.each_with_index do |w,i|
      step = steps[i]
      break if step.nil?
      if !@steps[step].nil? # first step isn't in @steps -- COULD MASK PROBLEMS!!!
        @steps[step].in_progress = true
      end
      w.start_step(step, step_duration(step))
    end
  end 

  def update_steps
    @workers.each_with_index do |w,id|
      next if w.step.nil?
      id = w.update
      execute_step(id) if !id.nil?
    end
  end

  def get_first_step
    (@steps.values.collect{|s| s.prereqs }.flatten.uniq - @steps.keys.uniq).first
  end

  def solve
    puts "#{self.class} (#{@filename}): #{@solution}"
  end
end

class D07P2Solver < Day07Solver
  def step_duration(id)
    (id.ord - 64) + @duration
  end

  def solve(num_workers, duration)
    @num_workers = num_workers
    @duration = duration
    process_steps
    @solution = @time
    super()
  end
end

class D07P1Solver < Day07Solver
  def step_duration(id)
    1
  end

  def solve
    @num_workers = 1
    process_steps
    @solution = @executed_steps.join
    super
  end
end

samplepath = "sampleinput.txt"
path = "input.txt"

D07P1Solver.new(samplepath).solve
D07P1Solver.new(path).solve
D07P2Solver.new(samplepath).solve(2, 0)
D07P2Solver.new(path).solve(5, 60)
