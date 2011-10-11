module Appetizer

  # Helps assign values from a low-level structure to a rich domain
  # model. Most useful as an explicit alternative to ActiveRecord's
  # mass-assignment, with an AR object as the target and a params hash
  # as the source.

  class Populator
    attr_reader :target
    attr_reader :source

    def initialize target, source, &block
      @target = target
      @source = source

      yield self if block_given?
    end

    def nested key, target = nil, &block
      source   = self.source[key] || self.source[key.intern]
      target ||= self.target.send key

      Populator.new target, source, &block if source
    end

    def set key, value = nil, &block
      value ||= source[key] || source[key.intern]

      return if value.nil? || (value.respond_to?(:empty?) && value.empty?)
      block ? block[value] : target.send("#{key}=", value)
    end

    # Helpers for using Populator in a Sinatra app.

    module Helpers

      # Call `ctor.new` to create a new model object, then populate,
      # save, and JSONify as in `update`.

      def create ctor, &block
        obj = populate ctor.new, &block
        obj.save!

        halt 201, json(obj)
      end

      # Use a populator to assign values from `params` to `obj`,
      # returning it when finished. `&block` is passed a populator
      # instance.

      def populate obj, &block
        Populator.new(obj, params, &block).target
      end

      # Populate (see `populate`) an `obj` with `params` data, saving
      # when finished. Returns JSON for `obj`.

      def update obj, &block
        populate(obj, &block).save!
        json obj
      end
    end
  end
end
