require_relative '../service/calendar_service'
require_relative '../service/cf_api'
require_relative '../database/booking'

require 'date'

describe Service::CalendarService do

  describe "#fetch_Schedule" do
    context "given date with no schedule" do
      it "returns all slots as free" do
        api_result = {
            "mentor" =>  {
              "name" => "Max Mustermann",
              "time_zone" => "-03:00"
            },
            "calendar" => [
              {
                "date_time" => "2021-12-29 17:10:09 +0200"
              },
              {
                "date_time" => "2021-12-30 13:11:55 +0100"
              },
              {
                "date_time" => "2021-12-31 23:43:20 +0100"
              }
            ]
          }
        allow_any_instance_of(Service::CfApi).to receive(:fetch_mentor_agenda).and_return(api_result)
        allow_any_instance_of(Database::Booking).to receive(:all_bookings_for_date).and_return([])

        cs = Service::CalendarService.new Date.parse("2022-01-01")
        schedule = cs.fetch_schedule
        schedule.each do |s|
          expect(s[:free]).to eq true
        end
      end
    end

    context "given date with n slots scheduled on api" do
      it "returns 1 slot as not free if 1 slot is filled" do
        api_result = {
            "mentor" =>  {
              "name" => "Max Mustermann",
              "time_zone" => "-03:00"
            },
            "calendar" => [
              {
                "date_time" => "2021-12-29 17:10:09 +0200"
              },
              {
                "date_time" => "2021-12-30 13:11:55 +0100"
              },
              {
                "date_time" => "2021-12-31 23:43:20 +0100"
              }
            ]
          }
        allow_any_instance_of(Service::CfApi).to receive(:fetch_mentor_agenda).and_return(api_result)
        allow_any_instance_of(Database::Booking).to receive(:all_bookings_for_date).and_return([])

        cs = Service::CalendarService.new Date.parse("2021-12-29")
        schedule = cs.fetch_schedule
        schedule.each do |s|
          slot_start = Time.parse(s[:slot_start_time])
          if slot_start.hour == 17
            expect(s[:free]).to eq false
          else
            expect(s[:free]).to eq true
          end
        end
      end
      it "returns 2 slot as not free if 2 slots are filled" do
        api_result = {
            "mentor" =>  {
              "name" => "Max Mustermann",
              "time_zone" => "-03:00"
            },
            "calendar" => [
              {
                "date_time" => "2021-12-29 17:10:09 +0200"
              },
              {
                "date_time" => "2021-12-29 14:30:09 +0200"
              },
              {
                "date_time" => "2021-12-30 13:11:55 +0100"
              },
              {
                "date_time" => "2021-12-31 23:43:20 +0100"
              }
            ]
          }
        allow_any_instance_of(Service::CfApi).to receive(:fetch_mentor_agenda).and_return(api_result)
        allow_any_instance_of(Database::Booking).to receive(:all_bookings_for_date).and_return([])

        cs = Service::CalendarService.new Date.parse("2021-12-29")
        schedule = cs.fetch_schedule
        schedule.each do |s|
          slot_start = Time.parse(s[:slot_start_time])
          if [17,14].include?(slot_start.hour) 
            expect(s[:free]).to eq false
          else
            expect(s[:free]).to eq true
          end
        end
      end
    end

    
  end
end