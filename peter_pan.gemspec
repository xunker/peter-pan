# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'peter_pan'

Gem::Specification.new do |spec|
  spec.name          = "peter_pan"
  spec.version       = PeterPan::VERSION
  spec.authors       = ["Matthew Nielsen"]
  spec.email         = ["xunker@pyxidis.org"]
  spec.description   = %q{A virtual screen buffer with viewport panning. For the Dream Cheeky LED sign and others.}
  spec.summary       = %q{A virtual screen buffer with viewport panning. For the Dream Cheeky LED sign and others.}
  spec.homepage      = "https://github.com/xunker/peter_pan"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
