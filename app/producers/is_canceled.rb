# frozen_string_literal: true

module Kafka
  module Producers
    module ThirdPartyBookings
      class IsCanceled
        include EventsService

        TOPIC = "events-3rd-party-bookings-by-uuid"

        attr_reader :tour

        def initialize(tour)
          @tour = tour
        end

        def self.call(*args)
          new(*args).call
        end

        def call
          produce(
            message: build_message,
            topic: TOPIC,
            partition_key: get_original_tour_uuid(tour)
          )
        end

        private

        def build_message
          Kafka::Events::ThirdPartyBookings::IsCanceled.new(tour).to_json
        end
      end
    end
  end
end
