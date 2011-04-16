# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'rotten/version'

Gem::Specification.new do |s|
  s.name        = "rotten"
  s.version     = Rotten::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["James Cook"]
  s.email       = ["jamecook@gmail.com"]
  s.summary     = %q{Wrapper for Rotten Tomatoes API}
  #s.description = %q{}

  s.required_rubygems_version = ">= 1.4.2"
  s.rubyforge_project         = "rotten"

  s.add_development_dependency "rspec"
  s.add_development_dependency "fakeweb"

  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths      = ["lib"]
end
