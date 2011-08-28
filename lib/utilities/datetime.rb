class DateTime
  # Transform a DateTime to a Time
  def to_time
    Time.parse(self.to_s)
  end
end
