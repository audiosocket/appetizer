require "sinatra/base"

module Appetizer
  module Sinatra
    module Opinions
      def self.registered app
        app.configure :production do
          require "rack/ssl"
          app.use ::Rack::SSL
        end

        app.use ::Rack::CommonLogger, App.log

        app.configure :development do
          require  "sinatra/reloader"
          app.register ::Sinatra::Reloader
          app.also_reload "lib/**/*.rb"
        end
      end

      ::Sinatra.register self
    end
  end
end
