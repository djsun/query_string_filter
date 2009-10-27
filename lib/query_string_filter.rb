require 'rubygems'
require 'treetop'
Treetop.load(File.dirname(__FILE__) + '/filter')

class QueryStringFilter
  
  def initialize
    @parser = FilterParser.new
  end
  
  def process(string)
    @parser.parse(string).eval
  end
  
end
