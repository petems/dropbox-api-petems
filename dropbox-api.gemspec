# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dropbox-api/version"

Gem::Specification.new do |s|
  s.name        = "dropbox-api"
  s.version     = Dropbox::API::VERSION
  s.authors     = ["Marcin Bunsch"]
  s.email       = ["marcin@futuresimple.com"]
  s.homepage    = "http://github.com/futuresimple/dropbox-api"
  s.summary     = "A Ruby client for the DropBox REST API."
  s.description = "To deliver a more Rubyesque experience when using the DropBox API."

  s.rubyforge_project = "dropbox-api"

  s.add_dependency 'hashie', '~> 2.0.5'
  s.add_dependency 'faraday', '~> 0.8.9'
  s.add_dependency 'faraday_middleware', '~> 0.9.0'
  s.add_dependency 'simple_oauth', '~> 0.2.0'

  s.add_dependency 'multi_json', '1.7.9'
  s.add_dependency 'oauth', '0.4.7'
  s.add_dependency 'hashie', '2.0.5'

  s.add_development_dependency 'rspec','2.14.1'
  s.add_development_dependency 'rake', '10.1.0'

  s.add_development_dependency 'webmock', '~> 1.15.0'
  s.add_development_dependency 'rspec', '~> 2.14.1'
  s.add_development_dependency 'rake', '~> 10.1.1'
  s.add_development_dependency 'simplecov', '~> 0.8.2'
  s.add_development_dependency 'vcr', '~> 2.8.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
