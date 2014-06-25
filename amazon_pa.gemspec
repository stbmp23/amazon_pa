# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'amazon_pa/version'

Gem::Specification.new do |spec|
  spec.name          = "amazon_pa"
  spec.version       = AmazonPa::VERSION
  spec.authors       = ["ms"]
  spec.email         = ["stbmp23@gmail.com"]
  spec.description   = "A Ruby interface to the Amazon Product Advertising API"
  spec.summary       = spec.description
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  #spec.add_dependency "nokogiri", "~>1.5.0"
  spec.add_dependency "faraday"
  spec.add_dependency "multi_xml"

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.0"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "simplecov"
end
