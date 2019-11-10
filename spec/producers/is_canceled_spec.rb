# frozen-string-literal: true

require "rails_helper"
require "delivery_boy/rspec"

RSpec.describe Kafka::Producers::ThirdPartyBookings::IsCanceled do
  subject { described_class.call(tour) }

  let(:topic) { "events-3rd-party-bookings-by-uuid" }
  let(:formatted_message) do
    {
      event: "ThirdPartyBookingIsCanceled",
      created_at: Time.now.utc,
      payload:
        {
          uuid: tour.uuid,
          original_tour_uuid: get_original_tour_uuid
        }
    }.to_json
  end

  let(:passenger) { create(:passenger) }
  let(:car) { create(:car) }

  let(:original_tour) do
    create_booked_tour(id: 123,
                       assigned_car: car,
                       passenger: passenger)
  end
  let(:tour) do
    create_booked_tour(assigned_car: car,
                       passenger: passenger,
                       original_tour_id: original_tour.id)
  end

  def get_original_tour_uuid
    return original_tour.uuid if original_tour.exists?

    tour.uuid
  end

  describe ".call" do
    before do
      Timecop.freeze(Time.local(2018))

      expect_any_instance_of(described_class).to receive(:produce)
        .with(message: formatted_message, topic: topic, partition_key: get_original_tour_uuid)
        .and_return(message: formatted_message,
                    topic: topic,
                    partition_key: get_original_tour_uuid)
    end

    it "returns successfull result" do
      expect(subject).to be_truthy
    end

    it "returns valid message" do
      expect(subject).to eq(topic: topic,
                            message: formatted_message,
                            partition_key: get_original_tour_uuid)
    end
  end

  describe "#produce" do
    it "emits message to kafka" do
      described_class.new(tour).produce(message: formatted_message,
                                        topic: topic,
                                        partition_key: get_original_tour_uuid)

      messages = DeliveryBoy.testing.messages_for(topic)
      first_message = messages[0]

      expect(messages.count).to eq(1)
      expect(first_message.value).to eq(formatted_message)
      expect(first_message.partition_key).to eq(get_original_tour_uuid)
    end
  end
end
