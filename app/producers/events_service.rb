# frozen_string_literal: true

module Kafka
  module Producers
    module EventsService
      def produce(message:, topic:, partition_key:)
        DeliveryBoy.deliver_async!(
          message,
          topic: topic,
          key: partition_key,
          partition_key: partition_key
        )
      rescue Kafka::BufferOverflow => error
        Kiev.event(:kafka_event_delivery_failed, message: error.message)
      end
    end
  end
end
