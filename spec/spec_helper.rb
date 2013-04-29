require 'bundler/setup'

require 'rspec'

require 'simplecov'
SimpleCov.start

require 'simplecov-rcov'
require 'simplecov-rcov-text'

class SimpleCov::Formatter::MergedFormatter
  def format(result)
    SimpleCov::Formatter::RcovFormatter.new.format(result)
    SimpleCov::Formatter::RcovTextFormatter.new.format(result)
    SimpleCov::Formatter::HTMLFormatter.new.format(result)
  end
end
SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter