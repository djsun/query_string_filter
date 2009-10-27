require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "QueryStringFilter" do
  
  before do
    @filter = QueryStringFilter.new
  end
  
  describe "basic" do
  
    it ": with string" do
      expected = {
        :name => /david/
      }
      ["name:david", "name : david"].each do |s|
        @filter.process(s).should == expected
      end
    end
  
    it ": with number" do
      expected = { :count => /77/ }
      ["count:77", "count : 77"].each do |s|
        @filter.process(s).should == expected
      end
    end
  
    it ">" do
      expected = { :value => { '$gt' => 12 } }
      ["value>12", "value > 12"].each do |s|
        @filter.process(s).should == expected
      end
    end
  
    it "<" do
      expected = { :value => { '$lt' => 12 } }
      ["value<12", "value < 12"].each do |s|
        @filter.process(s).should == expected
      end
    end
  
    it ">=" do
      expected = { :value => { '$gte' => 12 } }
      ["value>=12", "value >= 12"].each do |s|
        @filter.process(s).should == expected
      end
    end
  
    it "<=" do
      expected = { :value => { '$lte' => 12 } }
      ["value<=12", "value <= 12"].each do |s|
        @filter.process(s).should == expected
      end
    end
    
  end
  
  describe "compound" do
    
    it ": with 2 strings" do
      expected = {
        :title => /election|texas/
      }
      [
        "title:election,texas",
        "title : election , texas"
      ].each do |s|
        @filter.process(s).should == expected
      end
    end

    it ": with 3 strings" do
      expected = {
        :title => /election|texas|bob/
      }
      [
        "title:election,texas,bob",
      ].each do |s|
        @filter.process(s).should == expected
      end
    end
    
  end

end
