require 'logger'

class Computer
  NUM_REGISTERS = 6
  COMPUTER_LEVEL = Logger::INFO

  attr_reader :reg, :ip
  def initialize
    @reg = Array.new(NUM_REGISTERS){0}
    @ip = 0
    @ip_reg = nil
    @instructions = []
    @logger = Logger.new(STDERR)
    @logger.level = COMPUTER_LEVEL
  end

  def bind_ip(reg)
    @logger.debug "Binding instruction pointer to reg #{reg}"
    @ip_reg = reg
  end

  def set_ip(val)
    @ip = val
  end

  def set_registers(values)
    values.each_with_index {|v,i| @reg[i] = v}
  end

  def load_instructions(ins)
    @instructions = ins
  end

  def run(num=nil)
    count = 0
    loop do
      ins = @instructions[@ip]
      execute ins
      count += 1
      break if (@ip >= @instructions.length || @ip < 0)
      break if (!num.nil? && count == num)
    end
  end

  def execute(ins)
    @logger.debug "EXECUTING: #{ins}"
    @logger.debug "BEFORE: #{self}"
    @reg[@ip_reg] = @ip
    process_instruction(ins.op, ins.a, ins.b, ins.out)
    @ip = @reg[@ip_reg]
    @ip += 1
    @logger.debug "AFTER: #{self}\n\n"
  end

  def process_instruction(op, a, b, out)
    @reg[out] = case op
    when :addr
      @reg[a] + @reg[b]
    when :addi
      @reg[a] + b
    when :mulr
      @reg[a] * @reg[b]
    when :muli
      @reg[a] * b
    when :banr
      @reg[a] & @reg[b]
    when :bani
      @reg[a] & b
    when :borr
      @reg[a] | @reg[b]
    when :bori
      @reg[a] | b
    when :setr
      @reg[a]
    when :seti
      a
    when :gtir
      (a > @reg[b]) ? 1 : 0
    when :gtri
      (@reg[a] > b) ? 1 : 0
    when :gtrr
      (@reg[a] > @reg[b]) ? 1 : 0
    when :eqir
      (a == @reg[b]) ? 1 : 0
    when :eqri
      (@reg[a] == b) ? 1 : 0
    when :eqrr
      (@reg[a] == @reg[b]) ? 1 : 0
    end
  end

  def to_s
    "Instruction ponter: #{@ip}, Registers: #{@reg.inspect}"
  end
end

class Instruction
  attr_reader :op, :a, :b, :out
  def initialize(instruction)
    parts = instruction.split
    @op = parts[0].to_sym
    @a = parts[1].to_i
    @b = parts[2].to_i
    @out = parts[3].to_i
  end

  def to_s
    "#{self.class}: #{@op} #{@a} #{@b} #{@out}"
  end
end
