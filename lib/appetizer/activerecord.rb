require "active_record/base"
require "yaml"

ActiveRecord::Base.configurations = YAML.load File.read("config/database.yml")
ActiveRecord::Base.establish_connection env

if File.directory? "app/models"
  $:.unshift File.expand_path "app/models"
  Dir["app/models/**/*.rb"].sort.each { |f| require f[11..-4] }
end
