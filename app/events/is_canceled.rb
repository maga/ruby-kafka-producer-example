# frozen_string_literal: true

module Kafka
  module Events
    module ThirdPartyBookings
      class IsCanceled < Kafka::MessageBuilder

        self.event_name = "ThirdPartyBookingIsCanceled"

        def initialize(tour)
          super()
          @tour = tour
        end

        private

        attr_reader :tour

        def payload
          {
            uuid: tour.uuid,
            original_tour_uuid: original_tour_uuid
          }
        end
      end
    end
  end
end
