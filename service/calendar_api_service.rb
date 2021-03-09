require_relative './cf_api'

module Service
  class CalendarAPIService

    def initialize(date)
      @date = date
    end

    def slots
      return @filled_slots if defined?(@filled_slots)
      
      mentor_schedule = api.fetch_mentor_agenda
      all_slots = convert_to_time(mentor_schedule["calendar"])
      @filled_slots = slots_for_date(all_slots).map(&:hour)
    end

    def is_booked?(hour)
      slots.include?(hour)
    end

    private

    def api
      @api ||= CfApi.new
    end

    def convert_to_time(slots)
      slots.map {|slot| Time.parse(slot["date_time"])}
    end

    def slots_for_date(slots)
      slots.select do |slot|
        slot.to_date == @date
      end
    end
  end
end