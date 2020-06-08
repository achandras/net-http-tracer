# frozen_string_literal: true

require "bundler/setup"
require "net/http/instrumentation"
require "opentracing_test_tracer"
require "webmock/rspec"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
