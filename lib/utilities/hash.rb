class Hash
  # Returns a new hash with the results of running block once for every key in self
  def collect_keys
    each_with_object({}){ |(k,v),h| h[yield(k)] = v } if block_given?
  end
  alias_method :map_keys, :collect_keys
  
  # Returns a new hash with the results of running block once for every value in self
  def collect_values
    each_with_object({}){ |(k,v),h| h[k] = yield(v) } if block_given?
  end
  alias_method :map_values, :collect_values
  
  # Returns a new hash where all keys have been symbolized
  def symbolize_keys
    collect_keys{ |k| k.to_sym }
  end
end
