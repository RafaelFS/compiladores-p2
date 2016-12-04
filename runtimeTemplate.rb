# Memory size available
MAX_MEMORY_SIZE = 500

# Operations Opcode
NOP = 0;
READ = 1;
LOAD = 2;
ADD = 3;
PRINT = 4;

# Important addresses
INSTRUCTION = 32;
DATA = 34;
RESULT = 36;
VALUE = 255;
INITIAL_ADDRESS  = 256

class RuntimeEnvironment
  def initialize
    @memory = Array.new(MAX_MEMORY_SIZE, 0)
  end

  def memory
    @memory
  end

  def setup
    memory[INSTRUCTION]   = INITIAL_ADDRESS;
		memory[INSTRUCTION+1] = VALUE;
		memory[DATA+1] = VALUE;
		memory[RESULT+1] = VALUE;
		memory[RESULT+2] = LOAD;
		memory[RESULT+3] = INSTRUCTION;
		memory[RESULT+4] = VALUE;
		memory[RESULT+5] = 0;
		memory[RESULT+6] = VALUE;
  end

  def get(address)
    if isValidAddress?(address) then
      memory[address]
    else
      raiseInvalidAddressAccess(address)
    end
  end

  def put(address, value)
    if isValidAddress?(address) then
      memory[address] = value
    else
      raiseInvalidAddressAccess(address)
    end
  end

  def isValidAddress?(address)
    address > 0 &&  address < MAX_MEMORY_SIZE
  end

  def raiseInvalidAddressAccess(address)
    raise "Tried to access invalid address %d" % address
  end

  def load (program)
    currentAddress = INITIAL_ADDRESS
    program.each do |instruction|
      put(currentAddress, instruction)
      currentAddress += 1
    end
  end

  def run
    currentAddress = memory[INSTRUCTION]
    while currentAddress < MAX_MEMORY_SIZE - 1 do
      interpret
      currentAddress = memory[INSTRUCTION]
    end
    puts "Reached memory end"
  end

  def isCurrentInstructionValue?
    get(memory[INSTRUCTION]+1) == VALUE
  end

  def isCurrentInstructionReference?(opcode)
    get(opcode+1) == VALUE
  end

  def increaseInstructionRegister
    memory[INSTRUCTION] += 1
  end

  def executeNopInstruction
    increaseInstructionRegister
  end

  def executeValueInstruction(value)
    memory[RESULT] = value
    increaseInstructionRegister
    increaseInstructionRegister
  end

  def executeReadInstruction
    # evaluate next and interpret result as mem address
    # give back content of that address
    increaseInstructionRegister
    interpret
    memory[RESULT] = get(memory[RESULT])
  end

  def executeLoadInstruction
    # evaluate two parameters and interpret first one as
    # address, second as value to load in it
    increaseInstructionRegister
    interpret
    address = memory[RESULT]
    interpret
    value = memory[RESULT]
    put(address,value)
  end

  def executeAddInstruction
    # evaluate next two, interpret first as address, 2nd as value
    # add 2nd to value at 1st address and give back as result as well
    increaseInstructionRegister
    interpret
    address = memory[RESULT]
    interpret
    value = memory[RESULT]
    put(address,get(address)+value)
    memory[RESULT] = get(address)
  end

  def executePrintInstruction
    # evaluate what's next and print that value
    increaseInstructionRegister
    interpret
    puts memory[RESULT]
  end

  def retrieveValueByReference(opcode)
    #reference to variable value; do directly
    memory[RESULT] = get(opcode);
    increaseInstructionRegister
  end

  def jump(opcode)
    memory[DATA] = memory[INSTRUCTION] + 1;
    memory[INSTRUCTION] = opcode
    interpret
  end

  def interpret
    opcode = get(memory[INSTRUCTION])

    #puts "Intepreting op %d on address %d" % [opcode, memory[INSTRUCTION]]
		# Check if its a value
		if isCurrentInstructionValue? then
			executeValueInstruction(opcode)
		else
		  # Then its a operand/address
		  case opcode
      when NOP
				executeNopInstruction
			when READ
				executeReadInstruction
			when LOAD
				executeLoadInstruction
			when ADD
				executeAddInstruction
			when PRINT
				executePrintInstruction
			else
				if isCurrentInstructionReference?(opcode)  then
					retrieveValueByReference(opcode)
				else
          # It's a jump
					jump(opcode)
				end
      end
    end
  end
end

program1 = [4, 7, 255]
program2 = [4,32]
program3 = [2, 32, 255, 256, 255]
program4 = [2, 32, 256, 255]
program5 = [258, 262, 4, 999, 255, 257]
program6 = [Integer("0x0002"),
Integer("0x010a"),
Integer("0x00ff"),
Integer("0x0032"),
Integer("0x00ff"),
Integer("0x010c"),
Integer("0x010a"),
Integer("0x0004"),
Integer("0x010a"),
Integer("0x0119"),
Integer("0x0000"),
Integer("0x00ff"),
Integer("0x0003"),
Integer("0x0001"),
Integer("0x0022"),
Integer("0x0005"),
Integer("0x00ff"),
Integer("0x0002"),
Integer("0x0020"),
Integer("0x00ff"),
Integer("0x0003"),
Integer("0x0022"),
Integer("0x00ff"),
Integer("0x0001"),
Integer("0x00ff")]

runtime = RuntimeEnvironment.new
runtime.setup
runtime.load(program6)
runtime.run
