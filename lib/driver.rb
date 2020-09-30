require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @id = id
      @name = name
      @vin = vin
      @status = status
      @trips = trips

      unless @status == :AVAILABLE || @status == :UNAVAILABLE
        raise ArgumentError.new("Invalid status")
      end

      if @vin.length > 17 || @vin.length < 17
        raise ArgumentError.new("Invalid VIN")
      end

    end


    private

    def self.from_csv(record)
    return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status]
    )
    end
  end
end
