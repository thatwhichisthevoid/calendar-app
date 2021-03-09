require 'grape'

require_relative './calendar'
require_relative '../exceptions'

module API
	class Root < Grape::API
		version 'v1'
		format :json
		prefix :api

		rescue_from ::Exceptions::APIError do |e|
			error!(e, 500)
		end

		rescue_from ::Exceptions::ValidationError do |e|
			error!({ success: false, error: e.message }, 400)
		end

		mount API::Calendar
	end
end