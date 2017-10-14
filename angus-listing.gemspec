# -*- encoding: utf-8 -*-
# stub: angus-listing 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "angus-listing"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Adrian Gomez", "Gianfranco Zas", "Lesly Acuna", "Nicolas Suarez"]
  s.date = "2016-10-10"
  s.description = "Provides a query language for filtering, pagination, and sorting over specified datasets."
  s.files = ["CHANGELOG.md", "LICENSE", "README.md", "ROADMAP.md", "lib/angus", "lib/angus-listing.rb", "lib/angus/listing", "lib/angus/listing/aggregations", "lib/angus/listing/aggregations.rb", "lib/angus/listing/aggregations/base.rb", "lib/angus/listing/aggregations/sum_aggregation.rb", "lib/angus/listing/conditions", "lib/angus/listing/conditions.rb", "lib/angus/listing/conditions/and_condition.rb", "lib/angus/listing/conditions/between_condition.rb", "lib/angus/listing/conditions/equal_condition.rb", "lib/angus/listing/conditions/greater_than_or_equal_condition.rb", "lib/angus/listing/conditions/in_condition.rb", "lib/angus/listing/conditions/is_null_condition.rb", "lib/angus/listing/conditions/like_condition.rb", "lib/angus/listing/conditions/not_condition.rb", "lib/angus/listing/conditions/or_condition.rb", "lib/angus/listing/conditions/true_condition.rb", "lib/angus/listing/dataset.rb", "lib/angus/listing/q.rb", "lib/angus/listing/report.rb", "lib/angus/listing/utils.rb"]
  s.rubygems_version = "2.2.2"
  s.summary = "Gathers report data such as listings, counts, aggregations."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 3.1"])
      s.add_development_dependency(%q<rspec>)
      s.add_development_dependency(%q<rspec-its>)
      s.add_development_dependency(%q<rack-test>, ["= 0.6.1"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, ["= 0.7.1"])
      s.add_development_dependency(%q<simplecov-rcov>, ["= 0.2.3"])
      s.add_development_dependency(%q<simplecov-rcov-text>, ["= 0.0.2"])
      s.add_development_dependency(%q<ci_reporter>, ["= 1.7.0"])
      s.add_development_dependency(%q<sqlite3>)
    else
      s.add_dependency(%q<activerecord>, [">= 3.1"])
      s.add_dependency(%q<rspec>)
      s.add_dependency(%q<rspec-its>)
      s.add_dependency(%q<rack-test>, ["= 0.6.1"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<simplecov>, ["= 0.7.1"])
      s.add_dependency(%q<simplecov-rcov>, ["= 0.2.3"])
      s.add_dependency(%q<simplecov-rcov-text>, ["= 0.0.2"])
      s.add_dependency(%q<ci_reporter>, ["= 1.7.0"])
      s.add_dependency(%q<sqlite3>)
    end
  else
    s.add_dependency(%q<activerecord>, [">= 3.1"])
    s.add_dependency(%q<rspec>)
    s.add_dependency(%q<rspec-its>)
    s.add_dependency(%q<rack-test>, ["= 0.6.1"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<simplecov>, ["= 0.7.1"])
    s.add_dependency(%q<simplecov-rcov>, ["= 0.2.3"])
    s.add_dependency(%q<simplecov-rcov-text>, ["= 0.0.2"])
    s.add_dependency(%q<ci_reporter>, ["= 1.7.0"])
    s.add_dependency(%q<sqlite3>)
  end
end
