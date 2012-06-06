Gem::Specification.new do |s|
  s.name    = "mustache-rails"
  s.version = "0.0.0"

  s.homepage = "https://github.com/josh/mustache-rails"
  s.summary  = "Mustache Rails adapter"
  s.description = "Implements Mustache views and templates for Rails 3.x"

  s.files = Dir["README.md", "lib/**/*"]

  s.add_dependency "actionpack", "~>3.1"
  s.add_dependency "mustache", "~>0.99.4"
  s.add_development_dependency "rake"

  s.author = "Joshua Peek"
  s.email  = "josh@joshpeek.com"
end
