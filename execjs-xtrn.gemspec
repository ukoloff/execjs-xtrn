# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'execjs/xtrn/version'

Gem::Specification.new do |spec|
  spec.name          = "execjs-xtrn"
  spec.version       = ExecJS::Xtrn::VERSION
  spec.authors       = ["Stas Ukolov"]
  spec.email         = ["ukoloff@gmail.com"]
  spec.description   = "Drop-in replacement for ExecJS with persistent external runtime"
  spec.summary       = "Proof-of-concept: make ExecJS fast even without therubyracer"
  spec.homepage      = "https://github.com/ukoloff/execjs-xtrn"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)+
                       Dir.glob('**/node_modules/*/*.js')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "json", '~> 1.8'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "coffee-script", '2.3.0'
  spec.add_development_dependency "uglifier", '~> 2'
  spec.add_development_dependency "appveyor-worker"
end
