# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "friendly_admin/version"

Gem::Specification.new do |s|
  s.name        = "friendly_admin"
  s.version     = FriendlyAdmin::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['gzigzigzeo', 'gazay']
  s.email       = ['gzigzigzeo@gmail.com', 'alex.gaziev@gmail.com']
  s.homepage    = "https://github.com/gazay/friendly_admin"
  s.summary     = %q{Friendly admin}
  s.description = %q{Friendly admin}

  s.rubyforge_project = "friendly_admin"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rails', '~> 3.2'

  s.add_development_dependency 'sqlite3-ruby'
  s.add_development_dependency 'inherited_resources'
  s.add_development_dependency 'rspec-rails'
end
