def App.arconfig!
  require "active_record"
  require "uri"

  unless ENV["DATABASE_URL"]
    raise "No DATABASE_URL environment variable set."
  end

  url = URI.parse ENV["DATABASE_URL"]

  cfg = {
    adapter:  url.scheme,
    database: url.path[1..-1],
    encoding: "utf8",
    host:     url.host,
    password: url.password,
    port:     url.port,
    username: url.user
  }

  case url.scheme
  when "sqlite"
    cfg[:adapter] = "sqlite3"
    cfg[:database] = url.host
  when "postgres"
    cfg[:adapter] = "postgresql"
  end

  ActiveRecord::Base.configurations = { App.env.to_s => cfg }
  ActiveRecord::Base.logger = App.log
end

App.on :initializing do
  App.arconfig!
  ActiveRecord::Base.establish_connection App.env
end
