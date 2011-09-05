desc "A REPL, run `reload!` to reload."
task :console do
  require "appetizer/console"
  reload!
end
