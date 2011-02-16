module Kernel
  # Add .inspect to any object passed, than call Kernel.raise
  def raiser o
    raise o.inspect
  end
end

class Range
  # Return a range containing elements common to the two ranges, with no duplicates
  def intersection range
    values = self.to_a & range.to_a
    values.empty? ? nil : (values.first..values.last)  
  end  
  alias_method :&, :intersection
  
  # Detect if the two ranges overlap one with the other
  def overlap? range
    !(self & range).count.zero?
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
end

module Utilities
  module Statistics
    # Add each object of the array to each other in order to get the sum, as long as all objects respond to + operator
    def sum
      inject( nil ) do |sum, x|
        sum ? sum + x : x
      end
    end
    
    # Calculate the mean of the array, as long as all objects respond to / operator
    def mean
      (size > 0) ? sum.to_f / size : 0.0
    end
    alias_method :average, :mean
    
    # Calculate the number of occurences for each element of the array
    def frequences
      inject(Hash.new(0)) { |h, v| h[v] += 1; h }
    end
    
    # Return the variance of the array
    def variance
      m = mean
	    inject(0) { |v, x| v += (x - m) ** 2 }
    end
    
    # Return the standard deviation of the array
    def standard_deviation
	    size > 1 ? Math.sqrt( variance / ( size - 1 ) ) : 0.0
    end
    alias_method :std_dev, :standard_deviation
    
    # Return the median of the array
    def median(already_sorted=false)
      return nil if empty?
      a = sort unless already_sorted
      m_pos = size / 2
      size % 2 == 1 ? a[m_pos] : a[m_pos-1..m_pos].mean
    end
    
    # Return an array of modes with their corresponding occurences
    def modes
      freq = frequences
      max = freq.values.max
      freq.select { |k, f| f == max }
    end
    
    # Return all statistics from the array in a simple hash
    def stats
      {
        :size => size,
        :sum => sum,
        :min => min,
        :max => max,
        :mean => mean,
        :standard_deviation => standard_deviation,
        :median => median,
        :modes => modes
      }
    end
  end
end
