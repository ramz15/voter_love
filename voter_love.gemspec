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
  s.summary     = "An easy to use voting gem for Rails 3"
  s.description = "The voter_love Gem allows users to easily vote on objects"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.0"

  s.add_dependency "activerecord", "~> 3.0"
  s.add_development_dependency "bundler", "~> 1.0.0"
  s.add_development_dependency "database_cleaner", "0.6.7"
  s.add_development_dependency "sqlite3-ruby", "~> 1.3.0"
  s.add_development_dependency "rspec", "~> 2.5.0"
  s.add_development_dependency "generator_spec", "~> 0.8.2"
  
  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
  
end
