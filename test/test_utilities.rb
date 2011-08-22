require File.join(File.dirname(__FILE__), "..", "lib", "utilities")

describe Range do
  it "#intersection should returns a range containing elements common to the two ranges, with no duplicates" do
    (1..10).intersection(5..15).should == (5..10)
    (1..10).intersection(15..25).should == nil
  end
  
  it "#empty? should returns true if given Range is empty" do
    # Can a range be empty?
  end
  
  it "#overlap? should returns true if the given Range overlaps the other" do
    (1..5).overlap?(10..20).should == false
    (1..5).overlap?(4..9).should == true
    (1..5).overlap?(5..10).should == true
    (1...5).overlap?(5..10).should == false
  end
end

describe Numeric do
  it "#degrees should returns the right degrees for any given Numeric" do
    0.degrees.should   == 0
    90.degrees.should  == Math::PI / 2
    180.degrees.should == Math::PI
    360.degrees.should == Math::PI * 2
  end
  
  it "#square should returns the square of any given Numeric (based on Numeric ** method)" do
    (-5..5).each do |i|
      i.square.should == i**2
    end
  end
  
  it "#sqrt should returns the square root of any given Numeric (based on Math::sqrt)" do
    (1..25).each do |i|
      i.sqrt.should == Math::sqrt(i)
    end
  end
  
  it "#rank should returns the rank of any given Numeric" do
    1.rank(1, 5).should == (1.0 - 1.0) / (5.0 - 1.0)
    5.rank(3, 9).should == (5.0 - 3.0) / (9.0 - 3.0)
    -4.rank(1, 5).should == (-4.0 - 1.0) / (5.0 - 1.0)
    1.rank(1, 1).should == 0.0
  end
  
  it "#to_decimals should return a string of format %.nf" do
    1.to_decimals(1).should == "1.0"
    1.to_decimals(4).should == "1.0000"
    1.983.to_decimals.should == "1.98"
    1.987.to_decimals.should == "1.99"
    -1.531.to_decimals.should == "-1.53"
  end
  
  it "#percentage_of should return the percent of any given Numeric on n" do
    1.percentage_of(100).should == 1
    1.percentage_of(50).should == 2
    1.percentage_of(1).should == 100
    1.percentage_of(50, 50).should == 1
    100.percentage_of(50).should == 200
  end
end

describe Hash do
  it "#collect_keys should returns a new hash with the results of running block once for every key in self" do
    {"a"=>1, "b"=>2, "c"=>3}.collect_keys{|k| k + "z"}.should == {"az"=>1, "bz"=>2, "cz"=>3}
  end
  
  it "#collect_values should returns a new hash with the results of running block once for every value in self" do
    {"a"=>1, "b"=>2, "c"=>3}.collect_values{|v| v**2}.should == {"a"=>1, "b"=>4, "c"=>9}
  end
  
  it "#symbolize_keys should returns a new hash where all keys have been symbolized" do
    {"a"=>1, "b"=>2, "c"=>3}.symbolize_keys.should == {:a=>1, :b=>2, :c=>3}
  end
end

describe Enumerable do
  it "#collect_first should return the first collected elements" do
    h = {:a => 1, :b => 2, :c => 3}
    h.collect_first{|k, v| v if v == 2}.should == 2
    h.collect_first(1){|k, v| v}.should == [1]
    h.collect_first(2){|k, v| v}.should == [1, 2]
  end
end
