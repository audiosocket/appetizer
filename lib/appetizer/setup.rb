# Add the app's lib to the load path immediately.

$:.unshift File.expand_path "lib"

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

    fire :initializing

    load "config/init.rb" if File.exists? "config/init.rb"
    Dir["config/init/**/*.rb"].sort.each { |f| load f }

    # If the app has an app/models directory, autorequire 'em.

    if File.directory? "app/models"
      $:.unshift File.expand_path "app/models"
      Dir["app/models/**/*.rb"].sort.each { |f| require f[11..-4] }
    end

    fire :initialized

    @initialized = true
  end

  def self.load file
    now = Time.now.to_f if ENV["APPETIZER_TRACE"]
    Kernel.load file
    p :load => { file => (Time.now.to_f - now) } if ENV["APPETIZER_TRACE"]
  end

  def self.log
    @log ||= Logger.new test? ? "tmp/test.log" : $stdout
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

# Set default log formatter and level. WARN for production, INFO
# otherwise. Override severity with the `APPETIZER_LOG_LEVEL` env
# var. Formatter just prefixes with severity.

App.log.formatter = lambda do |severity, time, program, message|
  "[#{severity}] #{message}\n"
end

App.log.level = ENV["APPETIZER_LOG_LEVEL"] ?
  Logger.const_get(ENV["APPETIZER_LOG_LEVEL"].upcase) :
  App.production? ? Logger::WARN : Logger::DEBUG

def (App.log).write message
  self << message
end

# Make sure tmp exists, a bunch of things may use it.

FileUtils.mkdir_p "tmp"

# Load the global env files.

App.load "config/env.local.rb" if File.exists? "config/env.local.rb"
App.load "config/env.rb"       if File.exists? "config/env.rb"

# Load the env-specific file.

envfile = "config/env/#{App.env}.rb"
load envfile if File.exists? envfile

if defined? IRB
  IRB.conf[:PROMPT_MODE] = :SIMPLE

  App.require "appetizer/console"
  App.init!
end
