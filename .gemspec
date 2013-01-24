Gem::Specification.new do |s|
  s.name            = 'bancard-picasso-listing'
  s.version         = '0.0.1'
  s.platform        = Gem::Platform::RUBY
  s.authors         = ['Adrian Gomez', 'Gianfranco Zas', 'Lesly Acuna', 'Nicolas Suarez']
  s.summary         = 'Gathers report data such as listings, counts, aggregations.'
  s.description     = 'Provides a query language for filtering, pagination, and sorting over specified datasets.'

  s.files           = Dir.glob('{lib}/**/*') + %w(LICENSE README.md ROADMAP.md CHANGELOG.md)

  s.add_dependency('activerecord', '~> 3.1')

  s.add_development_dependency('rspec', '~> 2.12')
  s.add_development_dependency('rack-test', '0.6.1')
  s.add_development_dependency('simplecov', '0.6.4')
  s.add_development_dependency('ci_reporter', '1.7.0')
  s.add_development_dependency('rake')

  s.add_development_dependency('activerecord-jdbcsqlite3-adapter', '1.2.2.1') if RUBY_ENGINE == 'jruby'
  s.add_development_dependency('sqlite3', '1.3.6') if RUBY_ENGINE == 'ruby'
end
