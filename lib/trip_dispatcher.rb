require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

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

    def find_first_available_driver
      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          # driver.status = :UNAVAILABLE
          return driver
        else
          raise ArgumentError.new("Sorry! No available drivers")
        end
      end
    end
      # available_drivers = []
      # @drivers.each do |driver|
      #   if driver.status == :AVAILABLE
      #     available_drivers << driver #   raise ArgumentError.new("Sorry! No available drivers")
      #   end
      # end
      # max = driver[0]
      # available_drivers.each do |driver|
      #   if driver.end_time <
      #
      #   end
      #
      # end
      #end

    def request_trip(passenger_id)
      driver = find_first_available_driver
      # length of trips + 1 for id
      passenger = find_passenger(passenger_id)
      new_trip = RideShare::Trip.new(
                id: (@trips.length + 1),
                passenger: find_passenger(passenger_id),
                passenger_id: passenger_id,
                driver: driver,
                driver_id: driver.id,
                start_time: Time.now,
                end_time: nil,
                cost: nil,
                rating: nil
            )
      driver.add_trip(new_trip)
      # @trips << new_trip
      passenger.add_trip(new_trip)
      # driver.modify_driver
      driver.status = :UNAVAILABLE
      return new_trip
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

  end
end

