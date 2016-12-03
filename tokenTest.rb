require "./tokenTypes"
require "./operations"
require "./registers"

class TokenTest
  def initialize(type)
    @type = type
  end

  def type
    @type
  end

  def test(word)

  end
end

def isLabelDeclaration?(word)
  word =~ /[a-zA-Z][a-zA-Z\d]*:$/
end

class LabelDeclarationTest < TokenTest
  def initialize
    super(TOKEN_TYPE_LABEL_DECLARATION);
  end

  def test(word)
    isLabelDeclaration?(word)
  end
end

def isRegister?(word)
  registers.include?(word)
end

class RegisterTest < TokenTest
  def initialize
    super(TOKEN_TYPE_REGISTER);
  end

  def test(word)
    isRegister?(word)
  end
end

def isOperation?(word)
  operations.include?(word)
end

class OperationTest < TokenTest
  def initialize
    super(TOKEN_TYPE_OPERATION);
  end

  def test(word)
    isOperation?(word)
  end
end

def isIdentifier?(word)
  word =~ /[a-zA-Z].*$/
end

class IdentifierTest < TokenTest
  def initialize
    super(TOKEN_TYPE_IDENTIFIER);
  end

  def test(word)
    isIdentifier?(word)
  end
end

def isNumber?(word)
  word =~ /\d\d*$/
end

class NumberTest < TokenTest
  def initialize
    super(TOKEN_TYPE_NUMBER);
  end

  def test(word)
    isNumber?(word)
  end
end
