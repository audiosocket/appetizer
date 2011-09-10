def App.arconfig!
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
end

App.on :initializing do
  App.arconfig!
  ActiveRecord::Base.establish_connection App.env
end

if defined? Appetizer::Test  
  class Appetizer::Test
    module Fixtures
      def self.included klass
        fixtures = Dir["test/fixtures/*.yml"].map { |f| File.basename f, ".yml" }

        unless fixtures.empty?
          require "active_record/fixtures"
          ActiveRecord::Fixtures.create_fixtures "test/fixtures", fixtures, {}

          fixtures.each do |fixture|
            model = fixture.classify.constantize

            define_method fixture do |name|
              model.find ActiveRecord::Fixtures.identify name
            end
          end
        end
      end
    end

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
