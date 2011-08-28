class Object
  def within? enumerable
    if enumerable.is_a? Range
      enumerable.cover?(self)
    else
      enumerable.min <= self && self <= enumerable.max
    end
  end
end
