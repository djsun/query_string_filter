require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "QueryStringFilter" do
  
  before do
    @filter = QueryStringFilter.new
  end

  it ": with string" do
    expected = {
      :value => { '$gt' => 3 }
    }
    @filter.process("value>3").should == expected
    @filter.process("value > 3").should == expected
  end

  it ": with number" do
    expected = {
      :name => 'david'
    }
    @filter.process("name:david").should == expected
    @filter.process("name : david").should == expected
  end

  it ">" do
    expected = {
      :value => { '$gt' => 12 }
    }
    @filter.process("value>12").should == expected
    @filter.process("value > 12").should == expected
  end

  it "<" do
    expected = {
      :value => { '$lt' => 12 }
    }
    @filter.process("value<12").should == expected
    @filter.process("value < 12").should == expected
  end

  it ">=" do
    expected = {
      :value => { '$gte' => 12 }
    }
    @filter.process("value>=12").should == expected
    @filter.process("value >= 12").should == expected
  end

  it "<=" do
    expected = {
      :value => { '$lte' => 12 }
    }
    @filter.process("value<=12").should == expected
    @filter.process("value <= 12").should == expected
  end

end
