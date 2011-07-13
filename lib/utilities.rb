module Kernel
  # Add .inspect to any object passed, than call Kernel.raise
  def raiser o
    raise o.inspect
  end
end

class Object
  def within? enumerable
    if enumerable.is_a? Range
      enumerable.cover?(self)
    else
      enumerable.min <= self && self <= enumerable.max
    end
  end
end

class Range
  # Return a range containing elements common to the two ranges, with no duplicates
  def intersection range
    values = self.to_a & range.to_a
    values.empty? ? nil : (values.first..values.last)  
  end  
  alias_method :&, :intersection
  
  # Verify if self is empty
  def empty?
    count.zero?
  end
  
  # Detect if the two ranges overlap one with the other
  def overlap? range
    !(self & range).nil?
  end
  
  # Adds cover? if not defined (like in previous rubies)
  unless self.instance_methods.include(:cover?)
    def cover? object
      ends = [self.first, self.last]
      ends.min <= object && object <= ends.max
    end
  end
end

class DateTime
  # Transform a DateTime to a Time
  def to_time
    Time.parse(self.to_s)
  end
end

class Time  
  # Transform a Time to a DateTime
  def to_datetime
    DateTime.parse(self.to_s)
  end
end

class String  
  # Transform self to a Date
  def to_date
    Date.parse(self)
  end
  
  # Transform self to a Time
  def to_time
    Time.parse(self)
  end
end

class Numeric
  # Convert to degrees
  def degrees
    self * Math::PI / 180
  end
  
  # Return the square of self
  def square
    self * self
  end
  
  #Transform self to a string formatted time (HH:MM) Ex: 14.5 => “14:30“
  def hour_to_string delimiter = ':'
    hour  = self.to_i
    min   = "%02d" % (self.abs * 60 % 60).to_i
    "#{hour}#{delimiter}#{min}"
  end
  
  # Return the square root of self
  def sqrt
    Math.sqrt(self)
  end
  
  # Calculate the rank of self based on provided min and max
  def rank min, max
    s, min, max = self.to_f, min.to_f, max.to_f
    min == max ? 0.0 : (s - min) / (max - min)
  end
  
  # Transforms self to a string with *decimals* decimals
  def to_decimals decimals = 2
    "%.#{decimals}f" % self
  end
  
  # Calculate the percentage of self on n
  def percentage_of n, t = 100
    n == 0 ? 0.0 : self / n.to_f * t
  end
  alias_method :percent_of, :percentage_of
end

module Utilities
  module Submodules
    # Find every submodules of an object.
    def submodules
      constants.collect{ |const_name| const_get(const_name) }.select{ |const| const.class == Module }
    end
  end
  
  module Subclasses    
    # Find every subclass of an object.
    def subclasses(direct = false)
      classes = []
      
      if direct
        ObjectSpace.each_object(Class) do |c|
          classes << c if c.superclass == self
        end
      else
        ObjectSpace.each_object(Class) do |c|
          classes << c if c.ancestors.include?(self) and (c != self)
        end
      end
      
      classes
    end
  end
  
  module Statistics
    # Add each object of the array to each other in order to get the sum, as long as all objects respond to + operator
    def sum
      flatten.compact.inject( :+ )
    end
    
    # Calculate squares of each item
    def squares
      map{ |i| i**2 }
    end
    
    # Return a new array containing the rank of each value
    # Ex: [1, 2, 2, 8, 9] #=> [0.0, 1.5, 1.5, 3.0, 4.0]
    def ranks( already_sorted = false )
      a = already_sorted ? self : sort
      map{ |i| (a.index(i) + a.rindex(i)) / 2.0 }
    end
    
    # Calculate square roots of each item
    def sqrts
      map{ |i| i.sqrt }
    end
    
    # Calculate the mean of the array, as long as all objects respond to / operator
    def mean
      a = flatten.compact.to_stat
      (a.size > 0) ? a.sum.to_f / a.size : 0.0
    end
    alias_method :average, :mean
    
    # Calculate the number of occurences for each element of the array
    def frequences
      inject(Hash.new(0)) { |h, v| h[v] += 1; h }
    end
    
    # Return the variance of self
    def variance
      m = mean
      inject(0) { |v, x| v += (x - m) ** 2 }
    end
    
    # Return the (sample|population) standard deviation of self
    # If population is set to true, then we consider the dataset as the complete population
    # Else, we consider the dataset as a sample, so we use the sample standard deviation (size - 1)
    def standard_deviation( population = false )
	    size > 1 ? Math.sqrt( variance / ( size - ( population ? 0 : 1 ) ) ) : 0.0
    end
    alias_method :std_dev, :standard_deviation
    
    # Return the median of sorted self
    def median( already_sorted = false )
      return nil if empty?
      a = sort_and_extend( already_sorted )
      m_pos = size / 2
      size % 2 == 1 ? a[m_pos] : (a[m_pos-1] + a[m_pos]).to_f / 2
    end
    alias_method :second_quartile, :median
    
    # Return the first quartile of self
    def first_quartile( already_sorted = false )
      return nil if size < 4
      a = already_sorted ? self : sort
      a[0..((size / 2) - 1)].extend(Utilities::Statistics).median( true )
    end
    alias_method :lower_quartile, :first_quartile
    
    # Return the last quartile of self
    def last_quartile( already_sorted = false )
      return nil if size < 4
      a = already_sorted ? self : sort
      a[((size / 2) + 1)..-1].extend(Utilities::Statistics).median( true )
    end
    alias_method :upper_quartile, :last_quartile
    
    # Return an array containing the first, the second and the last quartile of self
    def quartiles( already_sorted = false )
      a = sort_and_extend( already_sorted )
      [a.first_quartile( true ), a.median( true ), a.last_quartile( true )]
    end
    
    # Calculate the interquartile range of self
    def interquartile_range( already_sorted = false )
      return nil if size < 4
      a = sort_and_extend( already_sorted )
      a.last_quartile - a.first_quartile
    end
    
    # Return an array of modes with their corresponding occurences
    def modes
      freq = frequences
      max = freq.values.max
      freq.select { |k, f| f == max }
    end
    
    # Return the midrange of sorted self
    def midrange( already_sorted = false )
      return nil if empty?
      a = sort_and_extend( already_sorted )
      (a.first + a.last) / 2.0
    end
    
    # Return the statistical range of sorted self
    def statistical_range( already_sorted = false )
      return nil if empty?
      a = sort_and_extend( already_sorted )
      (a.last - a.first)
    end
    
    # Return all statistics from self in a simple hash
    def statistics( already_sorted = false )
      sorted = sort_and_extend( already_sorted )
      
      {
        :first => self.first,
        :last => self.last,
        :size => self.size,
        :sum => self.sum,
        :min => self.min,
        :max => self.max,
        :mean => self.mean,
        :frequences => self.frequences,
        :variance => self.variance,
        :standard_deviation => self.standard_deviation,
        :modes => self.modes,
        
        # Need to be sorted...
        :ranks => sorted.ranks( true ),
        :median => sorted.median( true ),
        :midrange => sorted.midrange( true ),
        :statistical_range => sorted.statistical_range( true ),
        :quartiles => sorted.quartiles( true ),
        :interquartile_range => sorted.interquartile_range( true )
      }
    end
    alias_method :stats, :statistics
    
    protected
      def sort_and_extend( already_sorted = false )
        already_sorted ? self : sort.extend(Utilities::Statistics)
      end
  end
end

class Array
  # Returns true if the array contains only numerical values
  def numerics?( allow_nil = false )
    (allow_nil ? compact : self).reject{ |x| x.is_a?( Numeric ) }.empty?
  end
  alias_method :numeric?, :numerics?
  alias_method :narray?, :numerics?
  
  # Transforms an array
  def to_numerics
    map{ |x| x.to_f }
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
end
