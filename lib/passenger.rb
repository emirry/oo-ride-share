require_relative 'csv_record'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, phone_number:, trips: [])
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips
    end

    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures
      passenger_total_spent = 0

      if @trips == []
        raise ArgumentError.new("This passenger has 0 trips")
      end

      @trips.each do |trip|
        passenger_total_spent += trip.cost
      end
      return passenger_total_spent
    end

    def total_time_spent(trips)
      time = 0
      @trips.each do |trip|
        trip_time = calculate_trip_duration(trip)
        time += trip_time
      end
      return time
    end

    private

    def self.from_csv(record) #Child class
      return new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
  end
end
