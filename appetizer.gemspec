# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Audiosocket"]
  gem.email         = ["it@audiosocket.com"]
  gem.description   = "A thin shim for Rack app initialization and configuration."
  gem.summary       = "Provides environments, initializers, and helpers."
  gem.homepage      = "https://github.com/audiosocket/appetizer"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- test/*`.split("\n")
  gem.name          = "appetizer"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.0"

  gem.add_dependency "yajl-ruby", "~> 1.0"
end
