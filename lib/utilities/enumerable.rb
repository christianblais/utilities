module Enumerable  
  # Collects the first N truthy values
  # {}.collect_first {|a, b| obj} => obj
  # {}.collect_first(n) {|a, b| obj} => [obj]
  def collect_first( amount = nil, &block )
    array = !amount.nil?
    amount ||= 1
    
    values = []
    self.each do |val|
      break if values.length >= amount
      t = yield(val)
      values << t if t
    end
    
    !array && amount == 1 ? values.first : values
  end
  alias_method :map_first, :collect_first
end
