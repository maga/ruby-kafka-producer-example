# frozen_string_literal: true

module Kafka
  module Events
    module ThirdPartyBookings
      class IsUpdated < Kafka::MessageBuilder

        self.event_name = "ThirdPartyBookingIsUpdated"

        def initialize(tour)
          super()
          @tour = tour
        end

        private

        attr_reader :tour

        def payload
          {
            uuid: tour.uuid,
            booking_number: tour.tour_no,
            starts_at: tour.starts_at,
            pickup: tour.departure,
            dropoff: tour.destination,
            distance: tour.distance,
            price: tour.price,
            currency: tour.currency,
            pickup_sign: tour.sign,
            reference: tour.reference
          }
        end
      end
    end
  end
end
