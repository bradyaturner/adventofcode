INSTRUCTIONS = [
  :addr,
  :addi,
  :mulr,
  :muli,
  :banr,
  :bani,
  :borr,
  :bori,
  :setr,
  :seti,
  :gtir,
  :gtri,
  :gtrr,
  :eqir,
  :eqri,
  :eqrr
]

class WristComputer
  attr_reader :reg
  def initialize
    @reg = Array.new(4){0}
    @ins_map = {}
  end

  def set_registers(values)
    values.each_with_index {|v,i| @reg[i] = v}
  end

  def set_instruction_map(map)
    @ins_map = map
  end

  def process_opcode(opcode, a, b, out)
    op = @ins_map[opcode]
    process_instruction(op, a, b, out)
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
    "Register values: #{@reg.inspect}"
  end
end


class OpTest
  attr_reader :before, :instruction, :after
  def initialize(before, instruction, after)
    @before = before
    @instruction = Instruction.new(instruction)
    @after = after
  end

  def to_s
    "#{self.class}\n" +
    "\t#{@before.inspect}\n" +
    "\t#{@instruction}\n" +
    "\t#{@after.inspect}"
  end
end

class Instruction
  attr_reader :op, :a, :b, :out
  def initialize(instruction)
    parts = instruction.split.map(&:to_i)
    @op = parts[0]
    @a = parts[1]
    @b = parts[2]
    @out = parts[3]
  end

  def to_s
    "#{self.class}: #{@op} #{@a} #{@b} #{@out}"
  end
end
