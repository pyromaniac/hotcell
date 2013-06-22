# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hotcell/version'

Gem::Specification.new do |gem|
  gem.name          = "hotcell"
  gem.version       = Hotcell::VERSION
  gem.authors       = ["pyromaniac"]
  gem.email         = ["kinwizard@gmail.com"]
  gem.description   = %q{Sandboxed ruby template processor}
  gem.summary       = %q{Sandboxed ruby template processor}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "rake"
  gem.add_runtime_dependency "racc"
  gem.add_runtime_dependency "activesupport"
end
