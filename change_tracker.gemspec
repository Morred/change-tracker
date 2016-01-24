# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'change_tracker/version'

Gem::Specification.new do |spec|
  spec.name          = "change_tracker"
  spec.version       = ChangeTracker::VERSION
  spec.authors       = ["Laura Eck"]
  spec.email         = ["me@lauraeck.com"]
  spec.summary       = %q{A gem to track changes to your Active Record models' data}
  spec.description   = %q{A gem to track changes to your Active Record models' data for creating, updating and deleting}
  spec.homepage      = "https://github.com/Morred/change_tracker"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
end
