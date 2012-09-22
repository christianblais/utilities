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
      empty? ? 0 : flatten.compact.inject( :+ )
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
      (a.size > 0) ? a.sum.to_f / a.size : nil
    end
    alias_method :average, :mean
    
    # Calculate the number of occurences for each element of the array
    def frequences
      inject(Hash.new(0)) { |h, v| h[v] += 1; h }
    end
    
    # Return the variance of self
    def variance( population = false )
      return nil if empty?
      m = mean.to_f
      collect{|v| (v - m).square }.to_stats.sum / (size - (population ? 0 : 1))
    end
    
    # Return the (sample|population) standard deviation of self
    # If population is set to true, then we consider the dataset as the complete population
    # Else, we consider the dataset as a sample, so we use the sample standard deviation (size - 1)
    def standard_deviation( population = false )
      return nil if empty?
      size > 1 ? Math.sqrt( variance( population ) ) : 0.0
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
    
    # Return a hash of modes with their corresponding occurences
    def modes
      fre = frequences
      max = fre.values.max
      fre.select{ |k, f| f == max }
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
        :squares => self.squares,
        :sqrts => self.sqrts,
        :min => self.min,
        :max => self.max,
        :mean => self.mean,
        :frequences => self.frequences,
        :variance => self.variance,
        :standard_deviation => self.standard_deviation,
        :population_variance => self.variance(true),
        :population_standard_deviation => self.standard_deviation(true),
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
