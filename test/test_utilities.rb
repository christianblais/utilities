require "date"
require File.join(File.dirname(__FILE__), "..", "lib", "utilities")

describe Array do
  it "#numerics? should returns true if given Array contains only numeric values" do
    [].numerics?.should == true
    [1,2,3,4,5].numerics?.should == true
    [1,2,3,4,nil].numerics?.should == false
    [1,2,3,4,nil].numerics?(true).should == true
  end
  
  it "#to_numerics should returns a new array with only numeric elements" do
    [].to_numerics.should == []
    ["3", 4, nil].to_numerics.should == [3.0, 4.0, 0.0]
    ["3", 4, nil].to_numerics(true).should == [3.0, 4.0, nil]
  end
  
  it "#reverse_sort should reverse sort the given array" do
    [1,2,3,4].reverse_sort.should == [4,3,2,1]
    [4,3,2,1].reverse_sort.should == [4,3,2,1]
    ["f", "3", "z"].reverse_sort.should == ["z", "f", "3"]
  end
  
  it "#map_with should zip *args together and yield &block on them" do
    a = [1,2,3]
    b = [4,5,6]
    c = [7,8,9]
    
    a.map_with(b){ |i,j| i*j }.should == [4,10,18]
    a.map_with(b, c){ |i,j,k| i + j + k }.should == [12,15,18]
  end
  
  it "#to_stat should extends given array with module Utilities::Statistics" do
    [].methods.include?(:statistics).should == false
    [].to_stat.methods.include?(:statistics).should == true
  end
  
  it "#wrap should wrap the array as strings with the given parameters" do
    a = [1, 2, 3]
    b = ["a", "b", "c"]
    
    a.wrap("t").should == ["t1t", "t2t", "t3t"]
    b.wrap("c", "d").should == ["cad", "cbd", "ccd"]
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

describe Hash do
  it "#collect_keys should returns a new hash with the results of running block once for every key in self" do
    {"a"=>1, "b"=>2, "c"=>3}.collect_keys{|k| k + "z"}.should == {"az"=>1, "bz"=>2, "cz"=>3}
    {"a"=>1, "b"=>{"c"=>3}}.collect_keys{|k| k + "z"}.should == {"az"=>1, "bz"=>{"c"=>3}}
    {"a"=>1, "b"=>{"c"=>3}}.collect_keys(true){|k| k + "z"}.should == {"az"=>1, "bz"=>{"cz"=>3}}
  end
  
  it "#collect_values should returns a new hash with the results of running block once for every value in self" do
    {"a"=>1, "b"=>2, "c"=>3}.collect_values{|v| v**2}.should == {"a"=>1, "b"=>4, "c"=>9}
    lambda{ {"a"=>1, "b"=>{"c"=>3}}.collect_values{|v| v**2}.should raise_error( NoMethodError ) }
    {"a"=>1, "b"=>{"c"=>3}}.collect_values(true){|v| v**2}.should == {"a"=>1, "b"=>{"c"=>9}}
  end
  
  it "#symbolize_keys should returns a new hash where all keys have been symbolized" do
    {"a"=>1, "b"=>2, "c"=>3}.symbolize_keys.should == {:a=>1, :b=>2, :c=>3}
    {"a"=>1, "b"=>{"c"=>3}}.symbolize_keys.should == {:a=>1, :b=>{"c"=>3}}
    {"a"=>1, "b"=>{"c"=>3}}.symbolize_keys(true).should == {:a=>1, :b=>{:c=>3}}
  end
  
  it "#stringify_keys should returns a new hash where all keys have been stringified" do
    {:a=>1, :b=>2, :c=>3}.stringify_keys.should == {"a"=>1, "b"=>2, "c"=>3}
    {:a=>1, :b=>{:c=>3}}.stringify_keys.should == {"a"=>1, "b"=>{:c=>3}}
    {:a=>1, :b=>{:c=>3}}.stringify_keys(true).should == {"a"=>1, "b"=>{"c"=>3}}
  end
end

describe Kernel do
  it "#raiser should raise given object.inspect" do
    lambda{ raiser(1) }.should raise_error( RuntimeError, '1' )
    lambda{ raiser([:a, :b], 3, "test") }.should raise_error( RuntimeError, '[:a, :b], 3, "test"' )
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
  
  it "#hour_to_string should returns a formatted string of format HH:MM" do
    14.5.hour_to_string.should == "14:30"
    3.2.hour_to_string('h').should == "3h12"
    19.hour_to_string.should == "19:00"
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
    18.percentage_of(20, 5).should == 4.5
    100.percentage_of(50).should == 200
  end
end

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

describe String do
  it "#hour_to_float should returns a float represention of the hour" do
    "14:30".hour_to_float.should == 14.5
    "03h12".hour_to_float('h').should == 3.2
  end

  it "#float? check if self is a valid float or not" do
    "123.456".float?.should == true
    "1".float?.should == true
    ".456".float?.should == true
    "hello 123.456 world".float?.should == false
    "hello world".float?.should == false
    "123.456 hello".float?.should == false
    "hello 123.456".float?.should == false
  end
end

describe Utilities::Statistics do
  it "#statistics should returns a hash with all statistics included" do
    [1,2,3,4,5].to_stats.statistics.should == {
      :first=>1,
      :last=>5,
      :size=>5,
      :sum=>15,
      :squares=>[1, 4, 9, 16, 25],
      :sqrts=>[1.0, 1.4142135623730951, 1.7320508075688772, 2.0, 2.23606797749979],
      :min=>1,
      :max=>5,
      :mean=>3.0,
      :frequences=>{1=>1, 2=>1, 3=>1, 4=>1, 5=>1},
      :variance=>2.5,
      :standard_deviation=>1.5811388300841898,
      :population_variance=>2.0,
      :population_standard_deviation=>1.4142135623730951,
      :modes=>{1=>1, 2=>1, 3=>1, 4=>1, 5=>1},
      :ranks=>[0.0, 1.0, 2.0, 3.0, 4.0],
      :median=>3,
      :midrange=>3.0,
      :statistical_range=>4,
      :quartiles=>[1.5, 3, 4.5],
      :interquartile_range=>3.0
    }
  end
end

describe Object do
  it "#is_one? should return true if object is in the classes and false otherwise" do
    {:a => :b}.is_one?(Hash, Class).should be_true
    [].is_one?(Hash, Class).should be_false
    [].is_one?(Array).should be_true
    "".is_one?(Array).should be_false
  end
end
