# Entry point for Rakefiles.

require "appetizer/setup"

here = File.expand_path "..", __FILE__ # tasks from appetizer
Dir["#{here}/tasks/**/*.rake"].sort.each { |f| App.load f }

if File.exists? "config/database.yml"
  dbtasks = Gem.find_files "active_record/railties/databases.rake"
  App.load dbtasks.first unless dbtasks.empty?
end

# tasks from the app itself
Dir["lib/tasks/**/*.rake"].sort.each { |f| App.load f }
