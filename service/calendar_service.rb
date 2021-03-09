require 'date'
require 'time'

require_relative './calendar_api_service'
require_relative './booking_service'
require_relative '../exceptions'

module Service
  class CalendarService

    def initialize(date)
      @date = date
    end

    def fetch_schedule
      (0...24).map { |hour| generate_slot(hour) }
    end

    def add_slot(slot_time, reason)
      slot_hour = slot_time.hour
      if api_service.is_booked?(slot_hour) || booking_service.is_booked?(slot_hour)
        raise ::Exceptions::ValidationError.new("Slot has been already filled by event.")
      end
      booking_service.save_slot(slot_time, reason)
      slot(slot_hour).set_busy(reason)
    end

    private

    def generate_slot(hour)
      if api_service.is_booked?(hour)
        return slot(hour).set_busy
      end
      if booking_service.is_booked?(hour)
        reason = booking_service.reason_for_booking(hour)
        return slot(hour).set_busy(reason)
      end
      slot(hour).set_free
    end

    def api_service
      @api_service ||= CalendarAPIService.new @date
    end

    def booking_service
      @booking_service ||= BookingService.new @date
    end

    def slot(hour)
      Slot.new(@date, hour)
    end
  end

  class Slot

    def initialize(date, hour)
      @start_time = date.to_time + hour * 3600
      @end_time = @start_time + 3599
    end

    def set_free
      {
        slot_start_time: format_to_string(@start_time),
        slot_end_time: format_to_string(@end_time),
        free: true,
        reason: nil
      }
    end

    def set_busy(reason="Busy")
      {
        slot_start_time: format_to_string(@start_time),
        slot_end_time: format_to_string(@end_time),
        free: false,
        reason: reason
      }
    end

    private
    
    def format_to_string(date)
      date.strftime("%Y-%m-%d %H:%M")
    end
  end
end