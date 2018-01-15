# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'drive_info/version'

Gem::Specification.new do |spec|
  spec.name = 'drive_info'
  spec.version = DriveInfo::VERSION
  spec.authors = ['Diogo Dias']
  spec.email = ['e.diogodias@gmail.com']

  spec.summary = 'Drive travel information library'
  spec.homepage = 'https://github.com/batteries911/drive_info'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 0.13', '>= 0.13.1'
  spec.add_dependency 'faraday-encoding', '~> 0.0'
  spec.add_dependency 'faraday_middleware', '~> 0.12', '>= 0.12.2'
  spec.add_dependency 'redis', '~> 4.0'
  spec.add_dependency 'typhoeus', '~> 1.3'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'codacy-coverage'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'timecop'
end
