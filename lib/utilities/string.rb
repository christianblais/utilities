class String  
  # Transform self to a Date
  def to_date
    Date.parse(self)
  end
  
  # Transform self to a Time
  def to_time
    Time.parse(self)
  end

  # Transform a string of format HH:MM into a float representing an hour
  def hour_to_float(separator=':')
    m, s = self.split(separator).map(&:to_f)
    m + (s / 60)
  end
end
