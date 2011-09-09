# Entry point for Rakefiles.

require "appetizer/setup"

# Tasks from Appetizer. Only the first level, since other requires
# (like appetizer/rake/test) have their own tasks in subdirs.

here = File.expand_path "..", __FILE__
Dir["#{here}/tasks/*.rake"].sort.each { |f| App.load f }

# Load test tasks if the app appears to use tests.

if File.directory? "test"
  Dir["#{here}/tasks/test/*.rake"].sort.each { |f| App.load f }
end

# Tasks from the app itself.

Dir["lib/tasks/**/*.rake"].sort.each { |f| App.load f }
