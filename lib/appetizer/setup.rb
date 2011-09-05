# Add the app's lib to the load path.

$:.unshift File.expand_path "./lib"

require "logger"

module App
  def self.env
    (ENV["RACK_ENV"] || ENV["RAILS_ENV"] || "development").intern
  end

  def self.development?
    :development == env
  end

  def self.init!
    return true if defined?(@init) && @init

    envfile = "config/environments/#{App.env}.rb"
    load envfile if File.exists? envfile
    Dir["config/initializers/**/*.rb"].sort.each { |f| load f }

    if File.exists? "config/database.yml"
      require "active_record/base"
      require "yaml"

      ActiveRecord::Base.configurations = YAML.load File.read("config/database.yml")
      ActiveRecord::Base.establish_connection env
    end

    if File.directory? "app/models"
      $:.unshift File.expand_path "app/models"
      Dir["app/models/**/*.rb"].sort.each { |f| require f[11..-4] }
    end

    @init = true
  end

  def self.load file
    now = Time.now.to_f
    Kernel.load file
    p :load => { file => (Time.now.to_f - now) }
  end

  def self.port
    (ENV["PORT"] || 3000).to_i
  end

  def self.production?
    :production == env
  end

  def self.require file
    now = Time.now.to_f
    Kernel.require file
    p :require => { file => (Time.now.to_f - now) }
  end

  def self.test?
    :test == env
  end
end

App.load "config/env.local.rb" if File.exists? "config/env.local.rb"
App.load "config/env.rb"       if File.exists? "config/env.rb"

if defined? Rake
  here = File.expand_path "..", __FILE__ # tasks from appetizer
  Dir["#{here}/tasks/**/*.rake"].sort.each { |f| App.load f }

  # tasks from the app itself
  Dir["lib/tasks/**/*.rake"].sort.each { |f| App.load f }
end

if defined? IRB
  App.require "appetizer/console"

  IRB.conf[:PROMPT_MODE] = :SIMPLE
  App.init!
end
