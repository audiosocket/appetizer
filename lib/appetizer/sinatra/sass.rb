require "sass"
require "sinatra/base"

module Appetizer
  module Sinatra
    module Sass
      def self.registered app
        app.set :scss, cache_location: "tmp/sass-cache", style: :compact

        app.get "/css/screen.css" do
          scss :"css/screen"
        end
      end

      ::Sinatra.register self
    end
  end
end
