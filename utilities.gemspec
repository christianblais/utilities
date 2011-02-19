# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'lib/version'
 
Gem::Specification.new do |s|
  s.name        = "utilities"
  s.version     = Utilities::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Christian Blais", "Guillaume Malette"]
  s.email       = ["christ.blais@gmail.com", "gmalette@gmail.com"]
  s.homepage    = "http://github.com/christianblais/utilities"
  s.summary     = "Few utilities include in all my projects"
  s.description = "Few utilities include in all my projects, including a module for statistics, some to_date and to_time functions as well as intersection method for Range object."
 
  s.files = [
    'LICENSE',
    'README',
    'utilities.gemspec',
    'lib/utilities.rb',
    'lib/version.rb']
  
  s.require_paths = ['lib']
end
