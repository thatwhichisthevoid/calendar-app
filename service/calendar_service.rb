require 'date'
require 'time'

require_relative './cf_api_service'
require_relative '../database/booking'

module Service

  class CalendarService

    def fetch_schedule(date)
      @date = date
      (0...24).map do | hour |
        if filled_hours.include?(hour)
          filled_slot(hour, "Busy")
        elsif booked_hours.keys.map(&:to_i).include?(hour)
          filled_slot(hour, booked_hours[hour.to_s])
        else
          free_slot(hour)
        end
      end
    end

    def add_slot(slot_time, reason)
      @date = slot_time.to_date
      slot_hour = slot_time.hour
      total_filled_hours = filled_hours + booked_hours.keys.map(&:to_i)
      if total_filled_hours.include?(slot_hour)
        raise "Slot has been already filled by event."
      end
      save_slot(slot_time, reason)
      filled_slot(slot_hour, reason)
    end

    private

    def save_slot(slot_time, reason)
      end_time = slot_time + 3600
      booking_db_connection.add_booking(slot_time, end_time, reason)
    end

    def free_slot(hour)
      start_time = @date.to_time + hour * 3600
      end_time = start_time + 3599
      {
        slot_start_time: start_time.strftime("%Y-%m-%d %H:%M:%s"),
        slot_end_time: end_time.strftime("%Y-%m-%d %H:%M:%s"),
        free: true,
        reason: nil
      }
    end

    def filled_slot(hour, reason)
      free_slot(hour).merge(
        {
          free: false,
          reason: reason
        }
      )
    end

    def booked_hours
      return @booked_hours if defined?(@booked_hours)
      booked_slots = booking_db_connection.all_bookings_for_date(@date)
      @booked_hours = booked_slots.to_h
    end

    def filled_hours
      return @filled_hours if defined?(@filled_hours)
      mentor_schedule = api_service.fetch_mentor_agenda
      all_slots = convert_to_time(mentor_schedule["calendar"])
      @filled_hours = slots_for_date(all_slots).map(&:hour)
    end

    def api_service
      @api_service ||= CfApiService.new
    end

    def convert_to_time(slots)
      slots.map {|slot| Time.parse(slot["date_time"])}
    end

    def booking_db_connection
      @db_connection ||= Database::Booking.new
    end

    def slots_for_date(slots)
      slots.select do |slot|
        slot.to_date == @date
      end
    end
  end
end