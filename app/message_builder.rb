# frozen-string-literal: true

module Kafka
  class MessageBuilder
    attr_reader :created_at

    def initialize
      @created_at = Time.now.utc
    end

    def to_json
      @to_json ||= {
        event: self.class.event_name,
        created_at: created_at,
        payload: payload
      }.to_json
    end

    def key
      raise NotImplementedError
    end

    class << self
      attr_writer :event_name
      private :event_name=

      def event_name
        @event_name ||= name.split("::").last
      end
    end

    private

    def payload
      raise NotImplementedError
    end
  end
end
