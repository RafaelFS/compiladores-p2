require './token'
require "set"
require "./tokenTest"

def tokenTypesTests
  [
    LabelDeclarationTest.new,
    RegisterTest.new,
    OperationTest.new,
    IdentifierTest.new,
    NumberTest.new
  ]
end

def startsComment?(word)
  word =~ /\/\/.*/
end

def classify(word)
  tokenType = ""
  tokenTypesTests.each do |tokenTypeTest|
    if tokenTypeTest.test(word) then
      tokenType = tokenTypeTest.type
      break
    end
  end
  return tokenType
end

def extractAllTokens
  tokens = Array.new
  File.readlines("test6.l").each do |line|
    words = line.split

    words.each do |word|
      if startsComment?(word) then
        break
      else
        puts(word)
        token = Token.new
        token.type = classify(word)
        if token.type != "" then
          token.value = word
          tokens.push(token)
        else
          raise "Could not classify token!"
        end
      end
    end
  end
  tokens.each do |token|
    puts "type:%s value:%s" % [token.type, token.value]
  end
  return tokens
end

extractAllTokens
