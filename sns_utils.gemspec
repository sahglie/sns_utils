# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sns_utils/version'

Gem::Specification.new do |spec|
  spec.name          = "sns_utils"
  spec.version       = SnsUtils::VERSION
  spec.authors       = ["sahglie"]
  spec.email         = ["sahglie@gmail.com"]
  spec.description   = %q{Find and extract IP and MAC addresses in FILE}
  spec.summary       = %q{Find and extract IP and MAC addresses in FILE}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.files      += Dir.glob('lib/sns_utils/man/**/*')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "ronn"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec", "~> 2.7"
  spec.add_development_dependency "rake"
end
