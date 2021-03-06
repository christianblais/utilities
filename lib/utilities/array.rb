class Array
  # Returns true if the array contains only numerical values
  def numerics?( allow_nil = false )
    (allow_nil ? compact : self).reject{ |x| x.is_a?( Numeric ) }.empty?
  end
  alias_method :numeric?, :numerics?
  alias_method :narray?, :numerics?
  
  # Transforms an array to an array of float values
  def to_numerics( allow_nil = false )
    map{ |x| allow_nil && x.nil? ? nil : x.to_f }
  end
  alias_method :to_numeric, :to_numerics
  alias_method :to_narray, :to_numerics
  
  # Returns a copy of self reverse sorted
  def reverse_sort
    dup.rsort!
  end
  alias_method :rsort, :reverse_sort
  
  # Reverse sort self
  def reverse_sort!
    sort!{|x,y| y <=> x }
  end
  alias_method :rsort!, :reverse_sort!
  
  # Zip *args then call &block
  def map_with( *args, &block )
    zip(*args).map{|i| yield i }
  end
  
  # Returns a copy of self that includes the Statistics methods
  def to_stat
    dup.to_stat!
  end
  alias_method :to_stats, :to_stat
  
  # Adds the statistics methods to self
  def to_stat!
    extend(Utilities::Statistics)
  end
  alias_method :to_stats!, :to_stat!
  
  def wrap left_and_right, right = nil
    left_and_right = left_and_right.to_s
    right = right.nil? ? left_and_right : right.to_s
    map {|item| [left_and_right.to_s, item.to_s, right.to_s].join}
  end
end
