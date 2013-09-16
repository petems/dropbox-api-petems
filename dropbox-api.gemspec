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

  s.add_dependency 'multi_json'
  s.add_dependency 'oauth'
  s.add_dependency 'hashie'

  s.add_development_dependency 'webmock'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'ruby-debug19'
  s.add_development_dependency 'yajl-ruby'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
