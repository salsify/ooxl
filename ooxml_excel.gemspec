# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ooxl/version'

Gem::Specification.new do |spec|
  spec.name          = "ooxl"
  spec.version       = OOXL::VERSION
  spec.authors       = ["James Mones"]
  spec.email         = ["bajong009@gmail.com"]
  spec.summary       = %q{Lightweight Ruby parser for Excel spreadsheets (xlsx, xlsm).}
  spec.description   = %q{Parse Excel spreadsheets with a simple API. Read cell values, formulas, styles, comments, data validations, named ranges, and merged cells from xlsx and xlsm files. Supports streaming from strings and IO objects with lazy row loading for large files.}
  spec.homepage      = "https://github.com/halcjames/ooxl"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.3"

  spec.metadata = {
    "source_code_uri"   => "https://github.com/halcjames/ooxl",
    "bug_tracker_uri"   => "https://github.com/halcjames/ooxl/issues",
    "changelog_uri"     => "https://github.com/halcjames/ooxl/blob/master/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'activesupport'
  spec.add_dependency 'nokogiri', '~> 1'
  spec.add_dependency 'rubyzip', '~> 2.0'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
