# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fresh-auth/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Isaac Betesh"]
  gem.email         = ["iybetesh@gmail.com"]
  gem.description   = `cat README.md`
  gem.summary       = "Authenticates with the Freshbooks API and stores the authentication in a session with minimal configuration"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "fresh-auth"
  gem.require_paths = ["lib"]
  gem.version       = Fresh::Auth::VERSION
  gem.license       = 'MIT'
  gem.add_runtime_dependency 'rails', '>= 3.2.3'
end
