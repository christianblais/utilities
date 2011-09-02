Utilities
=========
Utilities provides a handful of useful goodies including statistics, numeric arrays and the well-known raiser.

Installation
------------
    gem install utilities

Test
----
    rspec test/test_utilities

Usage
-----
#### Array
* to_numerics

        ["3", 4, "7.9"].to_numerics #=> [3.0, 4.0, 7.9]
    
* numerics?

        [1, 2.0, 3].numerics? #=> true
    
* reverse_sort

        [1,8,3].reverse_sort #=> [8,3,1]

#### Enumerable
* collect_first

        {:a=>1, :b=>2, :c=>3}.collect_first{|k,v| [k, v * 3] if v == 2 } #=> [:b, 6]

#### Hash
* collect_keys

        {:a=>1, :b=>2, :c=>3}.collect_keys{|k| k.to_s.upcase } #=> {"A"=>1, "B"=>2, "C"=>3}
    
* collect_values

        {:a=>1, :b=>2, :c=>3}.collect_values{|v| v * -1 } #=> {:a=>-1, :b=>-2, :c=>-3}

* symbolize_keys

        {"a"=>1, "b"=>2}.symbolize_keys #=> {:a=>1, :b=>2}

#### Kernel
* raiser

        raiser 1, Hash.new, Array.new #=> RuntimeError "1, {}, []"

#### numeric
* degrees

        180.degrees == Math::PI #=> true

* square

        2.square #=> 4

* hour_to_string

        14.5.hour_to_string #=> "14:30"

* sqrt

        9.sqrt #=> 3

* rank

        5.rank(3, 9) #=> 0.3333...

* to_decimals

        1.759.to_decimals(2) #=> 1.76

* percentage_of

        48.percentage_of(50) #=> 96
