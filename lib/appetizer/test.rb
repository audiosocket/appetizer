ENV["RACK_ENV"] = ENV["RAILS_ENV"] = "test"

require "appetizer/init"
require "minitest/autorun"

module Appetizer
  class Test < MiniTest::Unit::TestCase
  end
end
