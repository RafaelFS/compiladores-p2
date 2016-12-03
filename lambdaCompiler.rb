require "./lex"
require 'optparse'

Options = Struct.new(:input)

class ArgumentParser
  def self.parse(options)
    args = Options.new("input.l")

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: lamdaCompiler.rb [options]"

      opts.on("-iFILE", "--input=FILE", "File to be used as input to the compiler (defaults to input.l)") do |i|
        args.input = i
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)
    return args
  end
end

options = ArgumentParser.parse(ARGV)
filename = options.input

extractAllTokens(filename)
