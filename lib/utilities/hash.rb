class Hash
  # Returns a new hash with the results of running block once for every key in self
  def collect_keys(recursive=false, &block)
    if block_given?
      each_with_object({}) do |(k,v),h|
        if recursive && v.kind_of?(Hash)
          h[yield(k)] = v.collect_keys(recursive, &block)
        else
          h[yield(k)] = v
        end
      end
    end
  end
  alias_method :map_keys, :collect_keys
  
  # Returns a new hash with the results of running block once for every value in self
  def collect_values(recursive=false, &block)
    if block_given?
      each_with_object({}) do |(k,v),h|
        if recursive && v.kind_of?(Hash)
          h[k] = v.collect_values(recursive, &block)
        else
          h[k] = yield(v)
        end
      end
    end
  end
  alias_method :map_values, :collect_values
  
  # Returns a new hash where all keys have been symbolized
  def symbolize_keys(recursive=false)
    collect_keys(recursive){ |k| k.to_sym }
  end
  
  # Returns a new hash where all keys have been stringified
  def stringify_keys(recursive=false)
    collect_keys(recursive){ |k| k.to_s }
  end
end
