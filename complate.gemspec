# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'complate/version'

Gem::Specification.new do |spec|
  spec.name          = "complate"
  spec.version       = Complate::VERSION
  spec.authors       = ["Till Schulte-Coerne", "Lucas Dohmen"]
  spec.email         = ["till.schulte-coerne@innoq.com",
						"lucas.dohmen@innoq.com"]

  spec.summary       = %q{Complate JSX on the server magic for ruby}
  spec.description   = %q{just do it}
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "therubyracer"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
