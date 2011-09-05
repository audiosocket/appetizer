task(:init) { App.init! }

task :environment do
  p fix: "somebody's calling the :environment task"
  Rake::Task[:init].invoke
end
