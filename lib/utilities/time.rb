class Time  
  # Transform a Time to a DateTime
  def to_datetime
    DateTime.parse(self.to_s)
  end
end

