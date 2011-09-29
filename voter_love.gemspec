$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "voter_love/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "voter_love"
  s.version     = VoterLove::VERSION
  s.authors     = ["Karl Gusner"]
  s.email       = ["karlgusner@gmail.com"]
  s.homepage    = "https://github.com/ramz15/voter_love"
  s.summary     = "an easy to use voting system"
  s.description = "simple voting gem for Ruby on Rails."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.0"

  s.add_development_dependency "sqlite3"
end
