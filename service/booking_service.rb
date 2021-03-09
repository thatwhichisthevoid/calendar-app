require_relative '../database/booking'

module Service
  class BookingService

    def initialize(date)
      @date = date
    end

    def schedule
      return @booked_hours if defined?(@booked_hours)
      booked_slots = booking_db_connection.all_bookings_for_date(@date)
      @booked_hours = booked_slots.to_h
    end

    def slots
      self.schedule.keys.map(&:to_i)
    end

    def is_booked?(hour)
      self.slots.include?(hour)
    end

    def reason_for_booking(hour)
      self.schedule[hour.to_s]
    end

    def save_slot(slot_time, reason)
      end_time = slot_time + 3600
      booking_db_connection.add_booking(slot_time, end_time, reason)
    end

    private

    def booking_db_connection
      @db_connection ||= Database::Booking.new
    end
  end
end