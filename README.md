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

* map_with

        [1,2,3].map_with([4,5,6]){|i,j| i * j }  #=> [4,10,18]

* warp

        [1, 2, 3].wrap("*") #=> ["*1*", "*2*", "*3*"]
        [1, 2, 3].wrap("*", "+") #=> ["*1+", "*2+", "*3+"]

#### Enumerable
* collect_first

        {:a=>1, :b=>2, :c=>3}.collect_first{|k,v| [k, v * 3] if v == 2 } #=> [:b, 6]

#### Hash
* collect_keys, map_keys (passing true as a parameter will collect keys recursively)

        {:a=>1, :b=>2, :c=>3}.collect_keys{|k| k.to_s.upcase } #=> {"A"=>1, "B"=>2, "C"=>3}
    
* collect_values, map_values (passing true as a parameter will collect values recursively)

        {:a=>1, :b=>2, :c=>3}.collect_values{|v| v * -1 } #=> {:a=>-1, :b=>-2, :c=>-3}

* symbolize_keys

        {"a"=>1, "b"=>2}.symbolize_keys #=> {:a=>1, :b=>2}

* stringify_keys

        {:a=>1, :b=>2}.stringify_keys #=> {"a"=>1, "b"=>2}

#### Kernel
* raiser

        raiser 1, Hash.new, Array.new #=> RuntimeError "1, {}, []"

#### Numeric
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

#### Object
* attempt

    Attempts to call a method on given object. If it fails (nil or NoMethodError), returns nil

        nil.attempt(:something) #=> nil
        "String".attempt(:wrong_method_name) #=> nil

#### String
* hour_to_float

        "14:30".hour_to_float #=> 14.5

* float?

        "123.456".float? #=> true

#### Utilities
* Statistics

    This module is intended to provide basic statistic functionnalities to numeric arrays. You may either
    call [].to_stats or extend an existing array with Utilities::Statistics module.

    * sum
    
            [1,2,3].sum #=> 6
    
    * squares
        
            [1,2,3].squares #=> [1,4,9]
    
    * sqrts
    
            [9,16,25].sqrts #=> [3,4,5]
    
    * mean
    
            [1,2,3,4,5].mean #=> 3
    
    * frequences
    
            [1,1,2,3,3,3,4].frequences #=> {1=>2, 2=>1, 3=>3, 4=>1}
    
    * modes
    
            [1,2,3,3,4,4,4,5].modes #=> {4=>3}
    
    * statistics
    
            [1,2,3,4,5].statistics #=> {
              :first=>1,
              :last=>5,
              :size=>5,
              :sum=>15,
              :squares=>[1, 4, 9, 16, 25],
              :sqrts=>[1.0, 1.4142135623730951, 1.7320508075688772, 2.0, 2.23606797749979],
              :min=>1,
              :max=>5,
              :mean=>3.0,
              :frequences=>{1=>1, 2=>1, 3=>1, 4=>1, 5=>1},
              :variance=>2.5,
              :standard_deviation=>1.5811388300841898,
              :population_variance=>2.0,
              :population_standard_deviation=>1.4142135623730951,
              :modes=>{1=>1, 2=>1, 3=>1, 4=>1, 5=>1},
              :ranks=>[0.0, 1.0, 2.0, 3.0, 4.0],
              :median=>3,
              :midrange=>3.0,
              :statistical_range=>4,
              :quartiles=>[1.5, 3, 4.5],
              :interquartile_range=>3.0
            }

