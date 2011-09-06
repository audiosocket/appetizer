module Appetizer
  module Events
    def fire event
      hooks[event].each { |h| h.call }
    end

    def hooks
      @hooks ||= Hash.new { |h, k| h[k] = h[k.to_s] || [] }
    end

    def on event, &block
      hooks[event] << block
    end
  end
end
