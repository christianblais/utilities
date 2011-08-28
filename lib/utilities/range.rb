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
  def cover? object
    ends = [self.first, self.last]
    ends.min <= object && object <= ends.max
  end unless self.instance_methods.include?(:cover?)
end
