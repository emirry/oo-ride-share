require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id)
      Driver.validate_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \ # What is this returning?
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect(passenger,driver)
      end
      return trips
    end

    #def find_first_available_driver
    #
    # end

    # change tests to ignore in progress trips!!!
    #def request_trip(passenger_id)
    # driver if driver == available (helper method?)
    # passenger_id = Passenger.new(id, email, address)
    # new_trip = Trip.new(
    #   id: ??
    #   passenger: passenger_id
    #   passenger_id: ??
    #   driver: that availble driver?
    #   driver_id: ??
    #   start_time: Time.now
    #   end_time: nil
    #   cost: nil
    #   rating: nil
    # )
    #
    # passenger.add_trip(new_trip)
    # end
  end
end
