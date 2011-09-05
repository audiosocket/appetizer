desc "Start the app with rackup and thin."
task :run, [:server] do |t, args|
  server  = args.server || "thin"
  exec "rackup", "-s", server, "-p", App.port.to_s
end
