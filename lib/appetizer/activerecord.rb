App.on :initializing do
  require "active_record"
  require "uri"

  unless ENV["DATABASE_URL"]
    raise "No DATABASE_URL environment variable set."
  end

  url = URI.parse ENV["DATABASE_URL"]

  cfg = {
    adapter:      url.scheme,
    database:     url.path[1..-1],
    encoding:     "utf8",
    host:         url.host,
    min_messages: "WARNING",
    password:     url.password,
    port:         url.port,
    username:     url.user
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

  ActiveRecord::Base.establish_connection App.env
end

if defined? Appetizer::Test
  class Appetizer::Test
    module Transactional
      def run runner
        result = nil

        ActiveRecord::Base.transaction do
          result = super
          raise ActiveRecord::Rollback
        end

        result
      end
    end

    include Transactional

    setup do
      ActiveRecord::IdentityMap.clear
    end
  end
end
