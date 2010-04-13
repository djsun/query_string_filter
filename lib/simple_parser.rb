require 'rubygems'
require 'treetop'
Treetop.load(File.dirname(__FILE__) + '/simple')

class StringParser
  
  class ParseError < RuntimeError; end
  
  def initialize
    @parser = SimpleParser.new
  end
  
  def parse(string)
    parsed = @parser.parse(string)
    raise ParseError, "unable to parse: #{string}" unless parsed
    parsed.eval
  end
  
end
