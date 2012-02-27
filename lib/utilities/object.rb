class Object
  def within? enumerable
    if enumerable.is_a? Range
      enumerable.cover?(self)
    else
      enumerable.min <= self && self <= enumerable.max
    end
  end

  # Attempts to call a method on given object. If it fails (nil or NoMethodError), returns nil
  def attempt method, *args, &block
    begin
      self.try(method, *args, &block)
    rescue NoMethodError
      nil
    end
  end

  def is_one?(*args)
    args.any? do |klass|
      self.is_a? klass
    end
  end
end
