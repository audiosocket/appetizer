module Appetizer

  # Helps assign values from a low-level structure to a rich domain
  # model. Most useful as an explicit alternative to ActiveRecord's
  # mass-assignment, with an AR object as the target and a params hash
  # as the source.

  module Populatable
    def populate source, context, &block
      Populator.new self, source, context, &block
    end

    class Populator
      attr_reader :context
      attr_reader :target
      attr_reader :source

      def initialize target, source, context, &block
        @context = context
        @target  = target
        @source  = source

        yield self if block_given?
      end

      def nested key, target = nil, &block
        source   = self.source[key] || self.source[key.intern]
        target ||= self.target.send key

        if source
          (block_given? or not Populatable === target) ?
            Populator.new(target, source, context, &block) :
            target.populate(source, context, &block)
        end
      end

      def set key, value = nil, &block
        value ||= source[key] || source[key.intern]

        return if value.nil? || (String === value && /\A\s*\Z/ =~ value)
        block ? block[value] : target.send("#{key}=", value)

        value
      end
    end
  end
end
