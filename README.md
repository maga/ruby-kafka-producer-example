# ruby-kafka-producer-example

Example of Apache Kafka producer.
## External libs, optional:
https://github.com/zendesk/delivery_boy
https://github.com/jeremyevans/sequel

## How to use
In transaction callback
```
Sequel::Model.db.transaction do
  Sequel::Model.db.after_commit do
    Kafka::Producers::ThirdPartyBookings::IsCanceled.call(tour)
  end
end

Sequel::Model.db.transaction do
  Sequel::Model.db.after_commit do
    Kafka::Producers::ThirdPartyBookings::IsUpdate.call(tour)
  end
end
```
