# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wms/version'

Gem::Specification.new do |spec|
  spec.name          = "wms"
  spec.version       = Wms::VERSION
  spec.authors       = ["Phoorichet Thepdusith"]
  spec.email         = ["phoorichet.t@gmail.com"]
  spec.description   = %q{Widget Management System core library}
  spec.summary       = %q{For experimental purposes}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
