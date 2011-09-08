desc "Run tests."
task :test do
  cmd = [
         "ruby",
         "-I", "test",
         "-r", "bundler/setup",
         "-r", "appetizer/setup",
         "-e", "Dir['test/**/*_test.rb'].each { |f| load f }"
        ]

  exec *cmd
end

task :default => :test
