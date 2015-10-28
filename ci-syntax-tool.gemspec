# coding: utf-8    # -*-ruby-*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ci-syntax-tool/version'

Gem::Specification.new do |spec|
  spec.name          = "ci-syntax-tool"
  spec.version       = CI::Syntax::Tool::VERSION
  spec.authors       = ["Clinton Wolfe"]
  spec.email         = ["clinton@omniti.com"]
  spec.description   = %q{Checks YAML, JSON, Ruby, ERB, and other syntaxes, then reports errors and OKs in a nice way for your CI system.}
  spec.summary       = %q{A Rubygem implementing a suite of source code syntax checkers, with well-behaved output fo use with CI engines.}
  spec.homepage      = "https://github.com/clintoncwolfe/ci-syntax-tool"
  spec.license       = "BSD (3-clause)"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", '~> 0.8'
  spec.add_development_dependency "cucumber", '~> 2.0'
  spec.add_development_dependency "rubocop", '~> 0.28'

end
