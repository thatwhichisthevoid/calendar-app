require_relative '../service/calendar_service'

module API
	class Calendar < Grape::API
		helpers do
			def calendar_service
				@service ||= ::Service::CalendarService.new
			end
		end
	
		params do
			requires :agenda_date, type: Date
		end
		get :mentor_agenda do
			date = params[:agenda_date]
			calendar_service.fetch_schedule(date)
		end

		params do
			requires :meeting_datetime, type: DateTime
			requires :reason, type: String
		end
		post :add_to_slot do
			meeting_datetime = params[:meeting_datetime]
			reason = params[:reason]
			calendar_service.add_slot(meeting_datetime, reason)
		end
	end
end