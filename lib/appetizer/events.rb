module Appetizer
  module Events
    def fire event
      hooks[event].each { |h| h.call }
    end

    def hooks
      @hooks ||= Hash.new { |h, k| Symbol === k ? h[k.to_s] : [] }
    end

    def on event, &block
      hooks[event.to_s] << block
    end
  end
end
