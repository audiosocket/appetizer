module Appetizer
  module Events
    def fire event
      hooks[event].each { |h| h.call }
    end

    def hooks
      @hooks ||= Hash.new { |h, k| h[k] = [] }
    end

    def on event, &block
      hooks[event] << block
    end
  end
end
