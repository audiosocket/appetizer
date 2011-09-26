ENV["RACK_ENV"] = ENV["RAILS_ENV"] = "test"

require "minitest/autorun"

module Appetizer
  class Test < MiniTest::Unit::TestCase
    def setup
      self.class.setups.each { |s| instance_eval(&s) }
    end

    def teardown
      self.class.teardowns.each { |t| instance_eval(&t) }
    end

    def self.setup &block
      setups << block
    end

    def self.setups
      @setups ||= (ancestors - [self]).
        map { |a| a.respond_to?(:setups) && a.setups }.
        select { |s| s }.
        compact.flatten.reverse
    end

    def self.teardown &block
      teardowns.unshift block
    end

    def self.teardowns
      @teardowns ||= (ancestors - [self]).
        map { |a| a.respond_to?(:teardowns) && a.teardowns }.
        select { |t| t}.
        compact.flatten
    end

    def self.test name, &block
      define_method "test #{name}", &block
    end
  end
end

require "appetizer/init"
