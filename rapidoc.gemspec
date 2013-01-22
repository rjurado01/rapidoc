# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rapidoc/version'

Gem::Specification.new do |gem|
  gem.name          = "rapidoc"
  gem.version       = Rapidoc::VERSION
  gem.authors       = ["Rafael Jurado"]
  gem.email         = ["rjurado@nosolosoftware.biz"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency  "rails", ">= 3.2.0"
  gem.add_development_dependency  "rspec-rails"
  gem.add_development_dependency  "sqlite3"
  gem.add_development_dependency  "handlebars", "~> 0.3.2"

end
