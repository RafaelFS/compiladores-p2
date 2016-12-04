require './token'
require "./tokenTest"
require "./runtimeTemplate"

def generate_code tokens
  set_references tokens
  get_code tokens
end

def set_references tokens
  pos = 0
  current_address = INITIAL_ADDRESS

  while pos < tokens.size
    current_token = tokens[pos]

    case current_token.type
    when TOKEN_TYPE_LABEL_DECLARATION
      add_label_reference current_token, current_address
      remove_token tokens, pos

    when TOKEN_TYPE_NUMBER, TOKEN_TYPE_REFERENCE
      insert_empty_token tokens, pos+1
      current_address += 2
      pos += 2

    when TOKEN_TYPE_REGISTER, TOKEN_TYPE_LABEL, TOKEN_TYPE_OPERATION
      current_address += 1
      pos += 1

    end
  end
end

def get_code tokens
  code = []
  tokens.each do |token|
    if token.nil?
      code.push("0x00FF".to_i(16))
    elsif token.type == TOKEN_TYPE_NUMBER
      code.push(token.value.to_i)
    elsif [TOKEN_TYPE_REGISTER, TOKEN_TYPE_OPERATION, TOKEN_TYPE_LABEL, TOKEN_TYPE_REFERENCE].include? token.type
      code.push(get_reference(token.value))
    end
  end
  code
end

def get_reference_table
  initialize_reference_table if @reference_table.nil?

  @reference_table
end

def initialize_reference_table
  @reference_table = Hash.new

  @reference_table["nop"] = NOP
  @reference_table["read"] = READ
  @reference_table["load"] = LOAD
  @reference_table["add"] = ADD
  @reference_table["print"] = PRINT

  @reference_table["instruction"] = INSTRUCTION
  @reference_table["data"] = DATA
  @reference_table["result"] = RESULT

end

def add_label_reference token, address
  table = get_reference_table

  label = token.value.gsub(":", "")

  if table[label].nil?
    table[label] = address
  else
    raise "Label %s is already defined" % label
  end
end

def get_reference value
  value.gsub!("!", "")

  if reference = get_reference_table[value]
    reference
  else
    raise "Reference for %s not found" % value
  end
end

def insert_empty_token tokens, pos
  tokens.insert pos, nil
end

def remove_token tokens, pos
  tokens.slice! pos
end
