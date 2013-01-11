class Numeric
  # Convert to degrees
  def degrees
    self * Math::PI / 180
  end
  
  # Return the square of self
  def square
    self * self
  end

  # Return a clamped value between a minimum and maximum value
  def clamp min, max
    [min, self, max].sort[1]
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
