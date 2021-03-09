require_relative '../service/calendar_service'

module API
	class Calendar < Grape::API
		helpers do
			def calendar_service(date)
				@service ||= ::Service::CalendarService.new(date)
			end
		end
	
		params do
			requires :agenda_date, type: Date
		end
		get :mentor_agenda do
			date = params[:agenda_date]
			calendar_service(date).fetch_schedule
		end

		params do
			requires :meeting_datetime, type: DateTime
			requires :reason, type: String
		end
		post :book_slot do
			meeting_datetime = params[:meeting_datetime]
			reason = params[:reason]
			result = calendar_service(meeting_datetime.to_date).add_slot(meeting_datetime, reason)
			{success: true, slot_info: result}
		end
	end
end