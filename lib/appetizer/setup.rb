# Add the app's lib to the load path immediately.

$:.unshift File.expand_path "./lib"

require "appetizer/events"
require "fileutils"
require "logger"

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

module App
  extend Appetizer::Events

  def self.env
    (ENV["RACK_ENV"] || ENV["RAILS_ENV"] || "development").intern
  end

  def self.development?
    :development == env
  end

  def self.init!
    return true if defined?(@initialized) && @initialized

    envfile = "config/{env,environments}/#{App.env}.rb"
    load envfile if File.exists? envfile

    fire :initializing

    Dir["config/{init,initializers}/**/*.rb"].sort.each { |f| load f }
    load "config/init.rb" if File.exists? "config/init.rb"

    fire :initialized

    @initialized = true
  end

  def self.load file
    now = Time.now.to_f if ENV["APPETIZER_TRACE"]
    Kernel.load file
    p :load => { file => (Time.now.to_f - now) } if ENV["APPETIZER_TRACE"]
  end

  def self.production?
    :production == env
  end

  def self.require file
    now = Time.now.to_f if ENV["APPETIZER_TRACE"]
    Kernel.require file
    p :require => { file => (Time.now.to_f - now) } if ENV["APPETIZER_TRACE"]
  end

  def self.test?
    :test == env
  end
end

# Make sure tmp exists, a bunch of things may use it.

FileUtils.mkdir_p "tmp"

App.load "config/env.local.rb" if File.exists? "config/env.local.rb"
App.load "config/env.rb"       if File.exists? "config/env.rb"

if defined? IRB
  IRB.conf[:PROMPT_MODE] = :SIMPLE

  App.require "appetizer/console"
  App.init!
end
