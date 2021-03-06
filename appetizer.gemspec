# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Audiosocket"]
  gem.email         = ["tech@audiosocket.com"]
  gem.description   = "A lightweight init process for Rack apps."
  gem.summary       = "Provides Railsy environments and initializers."
  gem.homepage      = "https://github.com/audiosocket/appetizer"

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- test/*`.split("\n")
  gem.name          = "appetizer"
  gem.require_paths = ["lib"]
  gem.version       = "0.2.0"

  gem.required_ruby_version = ">= 1.9.2"
end
