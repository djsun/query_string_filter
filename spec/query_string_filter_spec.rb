require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "QueryStringFilter" do
  
  before do
    @filter = QueryStringFilter.new
  end
  
  describe "failure" do
    it "no operator" do
      lambda {
        @filter.parse("something")
      }.should raise_error(QueryStringFilter::ParseError)
    end
    
    it "no quotes or connectives" do
      lambda {
        @filter.parse("name=David James")
      }.should raise_error(QueryStringFilter::ParseError)
    end
  end
  
  describe "keys" do
    it "key with underscore" do
      @filter.parse("with_underscore = test").should == {
        :with_underscore => "test"
      }
    end

    it "value with single quotes" do
      @filter.parse("foo = 'bar camp'").should == {
        :foo => "bar camp"
      }
    end
  end
  
  describe "basic operators" do
    it ": with string" do
      expected = {
        :name => /david/
      }
      ["name:david", "name : david"].each do |s|
        @filter.parse(s).should == expected
      end
    end
  
    it ": with number" do
      expected = { :count => /77/ }
      ["count:77", "count : 77"].each do |s|
        @filter.parse(s).should == expected
      end
    end

    it "= with string" do
      expected = {
        :name => "David"
      }
      [
        %(name=David),
        %(name = David)
      ].each do |s|
        @filter.parse(s).should == expected
      end
    end
  
    it ">" do
      expected = { :value => { '$gt' => 12 } }
      ["value>12", "value > 12"].each do |s|
        @filter.parse(s).should == expected
      end
    end
  
    it "<" do
      expected = { :value => { '$lt' => 12 } }
      ["value<12", "value < 12"].each do |s|
        @filter.parse(s).should == expected
      end
    end
  
    it ">=" do
      expected = { :value => { '$gte' => 12 } }
      ["value>=12", "value >= 12"].each do |s|
        @filter.parse(s).should == expected
      end
    end
  
    it "<=" do
      expected = { :value => { '$lte' => 12 } }
      ["value<=12", "value <= 12"].each do |s|
        @filter.parse(s).should == expected
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
        @filter.parse(s).should == expected
      end
    end

    it ": with 3 strings" do
      expected = {
        :title => /election|texas|bob/
      }
      [
        "title:election,texas,bob",
      ].each do |s|
        @filter.parse(s).should == expected
      end
    end
  end

end
