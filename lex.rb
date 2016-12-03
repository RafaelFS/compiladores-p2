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
  tokenTypesTests.each do |tokenTypeTest|
    if tokenTypeTest.test(word)
      puts tokenTypeTest.type
      break
    end
  end
end

File.readlines("test6.l").each do |line|
  words = line.split

  words.each do |word|
    if startsComment?(word) then
      break
    else
      puts(word)
      classify(word)
    end
  end

end
