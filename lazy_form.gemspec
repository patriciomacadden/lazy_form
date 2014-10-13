# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lazy_form'

Gem::Specification.new do |spec|
  spec.name          = 'lazy_form'
  spec.version       = LazyForm::VERSION
  spec.authors       = ['Patricio Mac Adden']
  spec.email         = ['patriciomacadden@gmail.com']
  spec.summary       = %q{Forms for the rest of us, the lazy.}
  spec.description   = %q{Forms for the rest of us, the lazy.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'cuba', '~> 3.3.0'
  spec.add_development_dependency 'hobbit', '~> 0.6.0'
  spec.add_development_dependency 'hobbit-contrib', '~> 0.7.1'
  spec.add_development_dependency 'oktobertest'
  spec.add_development_dependency 'oktobertest-contrib'
  spec.add_development_dependency 'sinatra', '~> 1.4.5'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_runtime_dependency 'inflecto'
end
