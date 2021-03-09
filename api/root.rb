require 'grape'
require 'grape-swagger'

require_relative './calendar'

module API
	class Root < Grape::API
		version 'v1'
		format :json
		prefix :api

		mount API::Calendar
	end
end