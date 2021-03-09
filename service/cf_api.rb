require 'uri'
require 'net/http'
require 'json'

require_relative '../exceptions'

module Service
  class CfApi

    def fetch_mentor_agenda
      uri = URI("#{base_url}/#{mentor_agenda_url}")
      response = Net::HTTP.get_response uri
      
      return JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
      
      raise ::Exceptions::APIError.new("Unable to fetch mentor schedule")
    end

    private
    
    def base_url
      'https://private-anon-578ff205e7-cfcalendar.apiary-mock.com/'
    end

    def mentor_agenda_url
      'mentors/1/agenda'
    end
  end
end