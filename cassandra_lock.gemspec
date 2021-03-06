# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cassandra_lock/version'

Gem::Specification.new do |spec|
  spec.name          = "cassandra_lock"
  spec.version       = CassandraLock::VERSION
  spec.authors       = ["Leandro Moreira"]
  spec.email         = ["leandro.ribeiro.moreira@gmail.com"]
  spec.summary       = %q{A ruby lib to achieve consensus with Cassandra}
  spec.homepage      = "https://github.com/leandromoreira/cassandra-lock"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "cassandra-driver"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.1"
end
