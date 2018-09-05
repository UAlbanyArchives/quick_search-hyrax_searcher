$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "quick_search/hyrax/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "quick_search-hyrax"
  s.version     = QuickSearch::Hyrax::VERSION
  s.authors     = ["gwiedeman"]
  s.email       = ["gregory.wiedeman1@gmail.com"]
  s.homepage    = "https://library.albany.edu/archive"
  s.summary     = "QuickSearch::Hyrax is a plugin for NCSU's quick_search application for searching a Hyrax repository"
  s.description = "QuickSearch::Hyrax is a minimal implementation for use in a bento-style discovery layer for querying a Hyrax digital repository."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.7"

  s.add_development_dependency "sqlite3"
end
