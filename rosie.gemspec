$:.push File.expand_path("../lib", __FILE__)
require "rosie/version"

Gem::Specification.new do |s|
  s.name        = "rosie"
  s.version     = Rosie::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jon Rogers", "Jeremy Yun"]
  s.email       = ["j@2rye.com"]
  s.homepage    = "http://github.com/2rye/rosie"
  s.summary     = "rosie-#{Rosie::VERSION}"
  s.description = %q{Backup/Restore MySQL database and dependent filesystem assets via rake tasks.}

  s.rubyforge_project = "rosie"
  
  s.add_development_dependency('rspec')
  s.add_development_dependency('rake', '~>0.9')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
