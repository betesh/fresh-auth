# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fresh/auth/version', __FILE__)

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
  gem.add_runtime_dependency 'builder', '>= 3.0.0'
  gem.add_runtime_dependency 'rest-client', '>= 1.6.7'
  gem.add_runtime_dependency 'nokogiri', '>= 1.5.5'
end
