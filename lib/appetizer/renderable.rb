require "yajl"

module Appetizer
  module Renderable
    def render context, &block
      Renderer.new self, &block
    end

    def json context
      Yajl::Encoder.encode render(context).data
    end

    # These exist to make integration with ActiveSupport's JSON
    # assumptions easier. In a world with no AS and no bullshit
    # `to_json` method pollution we wouldn't go this way.

    alias_method :to_json, :json

    def serializable_hash context
      render(context).data
    end

    # Helps turn a rich domain model into a low-level structure. The
    # `source` must have an attribute indexer like AR models
    # do. Ignores `nil` and `empty?` data.

    class Renderer
      attr_reader :source

      def initialize source, &block
        @data    = {}
        @source  = source

        yield self if block_given?
      end

      def data
        @data
      end

      def set key, value = nil, &transformer
        value ||= source.send key if source[key] || source.respond_to?(key)

        if value && transformer
          value = transformer[value]
        end

        # FIX: if value < Appetizer::Renderable or enumerable and first
        # is < A::R make a child context and extract or map/extract data.

        return if value.nil? || (String === value && /\A\s*\Z/ =~ value)

        set! key, value
      end

      def set! key, value
        data[key] = value
      end
    end
  end
end
