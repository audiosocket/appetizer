module Appetizer
  module Rack
    class Placeholder
      def initialize root = "public", glob = "**/*", &fallback
        fallback ||= lambda { |env|
          [404, { "Content-Type" => "text/plain" }, []]
        }

        urls = Dir[File.join root, glob].sort.
          select { |f| File.file? f }.
          map    { |f| f[root.length..-1] }

        @static = ::Rack::Static.new fallback, root: root, urls: urls
      end

      def call env
        if env["PATH_INFO"] == "/"
          env["PATH_INFO"] = "/index.html"
        end

        @static.call env
      end

      def self.call env
        new.call env
      end
    end
  end
end
