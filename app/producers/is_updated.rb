# frozen_string_literal: true

module Kafka
  module Producers
    module ThirdPartyBookings
      class IsUpdated
        include EventsService

        TOPIC = "events-3rd-party-bookings-by-uuid"

        attr_reader :tour

        # the parameter :tour is, in a case of ... :
        # a) create_by_update => the newly created tour
        # b) default update  => the original tour
        def initialize(updated_tour)
          @tour = updated_tour
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
          Kafka::Events::ThirdPartyBookings::IsUpdated.new(tour).to_json
        end
      end
    end
  end
end
