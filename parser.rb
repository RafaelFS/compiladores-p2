require './token'
require './tokenTypes'

def invalidSyntax(token)
  raise "Syntax was not valid after processing token type: %s value %s" % [token.type, token.value]
end

def cmd (tokens, index)
  currentState = "q0"
  syntaxMatch = false
  currentToken = tokens[index]

  while !syntaxMatch do
    case currentState
    when "q0"
      case currentToken.type
      when TOKEN_TYPE_OPERATION
        case currentToken.value
        when "nop"
          currentState = "q1"
        when "read","print"
          currentState = "q3"
          index += 1
          currentToken = tokens[index]
        when "load","add"
          currentState = "q2"
          index += 1
          currentToken = tokens[index]
        else
          invalidSyntax(currentToken)
        end
      else
        invalidSyntax(currentToken)
      end
    when "q2"
      expr(tokens, index)
      currentState = "q3"
      index += 1
      currentToken = tokens[index]
    when "q3"
      expr(tokens, index)
      currentState = "q1"
    when "q1"
      puts "Matched COMMAND"
      syntaxMatch = true
    else
      invalidSyntax(currentToken)
    end
  end
end


def expr (tokens, index)
  currentState = "q0"
  syntaxMatch = false
  currentToken = tokens[index]

  while !syntaxMatch do
    case currentState
    when "q0"
      case currentToken.type
      when TOKEN_TYPE_LABEL, TOKEN_TYPE_NUMBER, TOKEN_TYPE_REFERENCE, TOKEN_TYPE_REGISTER
        currentState = "q1"
      else
        cmd(tokens, index)
        currentState = "q1"
      end
    when "q1"
      puts "Matched EXPRESSION"
      syntaxMatch = true
    else
      raise "Syntax was not valid after processing token type: %s value %s" % [currentToken.type, currentToken.value]
    end
  end
end

def program(tokens, index)
  currentState = "q0"
  syntaxMatch = false
  currentToken = tokens[index]

  while !syntaxMatch do
    case currentState
    when "q0"
      case currentToken.type
      when TOKEN_TYPE_LABEL_DECLARATION
        currentState = "q1"
      else
        expr(tokens, index)
        currentState = "q1"
      end
    when "q1"
      syntaxMatch = true
    else
      invalidSyntax(currentToken)
    end
  end

  index += 1
  if(index < tokens.length)
    program(tokens, index)
  else
    puts "Matched PROGRAM"
  end
end

def parse(tokens)
  index = 0
  program(tokens, index)
end
