require "securerandom"

# Rack middleware to deal with CSRF protection. By default, requires a
# `csrf` param or `X-CSRF` HTTP header for any request that isn't
# `GET` or `HEAD`. Returns status `400` for requests without a valid
# token. Pass a block to the constructor to add custom exceptions:
#
#    use Appetizer::Rack::CSRF do |request|
#      request.path.include? "/skip-csrf-protection-for-me"
#    end

module Appetizer
  module Rack
    class CSRF
      def initialize app, &block
        @app    = app
        @exempt = block || lambda { |r| false }
      end

      class << self
        attr_accessor :header, :param
      end

      self.header = "HTTP_X_CSRF"
      self.param  = "csrf"

      def self.tag env
        "<input type='hidden' name='#{param}' value='#{token env}'>"
      end

      def self.token env
        env["rack.session"][param]
      end

      def call env
        request = ::Rack::Request.new env
        token   = token! env
        rtoken  = env[header] || request.POST[param]
        valid   = rtoken == token

        if request.get? || request.head? || valid || @exempt[request]
          return @app.call env
        end

        [400, { "Content-Type" => "text/plain" }, "Bad or missing CSRF token."]
      end

      def header
        self.class.header
      end

      def param
        self.class.param
      end

      def token env
        self.class.token env
      end

      def token! env
        env["rack.session"][param] ||= SecureRandom.hex 20
      end
    end
  end
end
