require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "StringParser" do
  
  before do
    @parser = StringParser.new
  end
  
  it %("123") do
    @parser.parse(%("123")).should == "123"
  end

  it %('123') do
    @parser.parse(%('123')).should == "123"
  end

  it %('123A') do
    @parser.parse(%('123A')).should == "123A"
  end

  it %(123A) do
    @parser.parse(%(123A)).should == "123A"
  end

end
