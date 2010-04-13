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
  
  describe "=" do
    it "with a number" do
      @filter.parse("year = 2008").should == {
        'year' => 2008
      }
    end

    it "with a single quoted number" do
      @filter.parse("year = '2008'").should == {
        'year' => '2008'
      }
    end

    it "with a double quoted number" do
      @filter.parse(%(year = "2008")).should == {
        'year' => '2008'
      }
    end
    
    it "with a single quoted string" do
      @filter.parse("foo = 'bar camp'").should == {
        "foo" => "bar camp"
      }
    end

    it "with a double quoted string" do
      @filter.parse(%(foo = "bar camp")).should == {
        "foo" => "bar camp"
      }
    end

    it "with http://" do
      @filter.parse("url = http://cnn.com").should == {
        "url" => "http://cnn.com"
      }
    end

    it "with true" do
      expected = {
        "top_level" => true
      }
      [
        %(top_level=true),
        %(top_level = true)
      ].each do |s|
        @filter.parse(s).should == expected
      end
    end

    it "with false" do
      expected = {
        "top_level" => false
      }
      [
        %(top_level=false),
        %(top_level = false)
      ].each do |s|
        @filter.parse(s).should == expected
      end
    end
    
    it "with string" do
      expected = {
        "name" => "David"
      }
      [
        %(name=David),
        %(name = David)
      ].each do |s|
        @filter.parse(s).should == expected
      end
    end

    it "with 1 id" do
      expected = { "id" => '224bc480f905f74b4c0c000011' }
      s = "id=224bc480f905f74b4c0c000011"
      @filter.parse(s).should == expected
    end
    
    it "with 2 ids" do
      expected = {
        "id" => '224bc480f905f74b4c0c000011,4bc481ce05f74b4c100000f7'
      }
      [
        "id=224bc480f905f74b4c0c000011,4bc481ce05f74b4c100000f7",
        "id = 224bc480f905f74b4c0c000011 , 4bc481ce05f74b4c100000f7"
      ].each do |s|
        @filter.parse(s).should == expected
      end
    end

    it "with 2 strings" do
      expected = {
        "title" => 'election,texas'
      }
      [
        "title=election,texas",
        "title = election , texas"
      ].each do |s|
        @filter.parse(s).should == expected
      end
    end

    it "with underscored key" do
      @filter.parse("with_underscore = test").should == {
        "with_underscore" => "test"
      }
    end

    it "with period in key" do
      @filter.parse("released.year = 2008").should == {
        'released.year' => 2008
      }
    end
  end
  
  describe ":" do
    it "with string" do
      expected = {
        "name" => /david/
      }
      ["name:david", "name : david"].each do |s|
        @filter.parse(s).should == expected
      end
    end
  
    it "with number" do
      expected = { "count" => /77/ }
      ["count:77", "count : 77"].each do |s|
        @filter.parse(s).should == expected
      end
    end

    it "with 2 strings" do
      expected = {
        "title" => /election|texas/
      }
      [
        "title:election,texas",
        "title : election , texas"
      ].each do |s|
        @filter.parse(s).should == expected
      end
    end

    it "with 3 strings" do
      expected = {
        "title" => /election|texas|bob/
      }
      [
        "title:election,texas,bob",
      ].each do |s|
        @filter.parse(s).should == expected
      end
    end
  end
  
  describe "comparators" do
    it ">" do
      expected = { "value" => { '$gt' => 12 } }
      ["value>12", "value > 12"].each do |s|
        @filter.parse(s).should == expected
      end
    end
  
    it "<" do
      expected = { "value" => { '$lt' => 12 } }
      ["value<12", "value < 12"].each do |s|
        @filter.parse(s).should == expected
      end
    end
  
    it ">=" do
      expected = { "value" => { '$gte' => 12 } }
      ["value>=12", "value >= 12"].each do |s|
        @filter.parse(s).should == expected
      end
    end
  
    it "<=" do
      expected = { "value" => { '$lte' => 12 } }
      ["value<=12", "value <= 12"].each do |s|
        @filter.parse(s).should == expected
      end
    end
  end
  
  describe "and" do
    it "double" do
      actual = %(format="xml" and count=13)
      @filter.parse(actual).should == {
        "format" => "xml",
        "count"  => 13,
      }
    end

    it "triple" do
      actual = %(format="xml" and count=13 and size=64)
      @filter.parse(actual).should == {
        "format" => "xml",
        "count"  => 13,
        "size"   => 64,
      }
    end
  end

end
