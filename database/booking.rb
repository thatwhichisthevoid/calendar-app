require 'sqlite3'

module Database
  class Booking
    def initialize
      @db = SQLite3::Database.new "booking.db"
    end

    def all_bookings_for_date(date)
      stmt = @db.prepare "SELECT strftime('%H', slot_start_time), reason from bookings where strftime('%Y-%m-%d', slot_start_time)=:date"
      stmt.execute date.to_s
    end

    def add_booking(start_time, end_time, reason)
      slot_start_time = start_time.strftime("%Y-%m-%d %H:%M")
      slot_end_time = end_time.strftime("%Y-%m-%d %H:%M")
      stmt = @db.prepare "INSERT INTO bookings(slot_start_time, slot_end_time, reason) VALUES (:slot_start_time, :slot_end_time, :reason)"
      stmt.execute slot_start_time, slot_start_time, reason
    end
  end
end