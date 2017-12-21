# frozen_string_literal: true

module DriveInfo
  module Providers
    require_relative 'here/route_time'

    class Here
      attr_reader :app_id, :app_code, :production

      def initialize(options = {})
        @app_id = options[:app_id]
        @app_code = options[:app_code]
        @production = options[:production] || false
      end

      def route_time(options = {})
        RouteTime.request(options.merge(options_data))
      end

      def parse(method, response)
        case method.to_sym
        when :route_time
          parse_route_time(response)
        else
          fail "Invalid method for parsing #{method}"
        end
      end

      private

      def options_data
        {
          app_id: app_id,
          app_code: app_code,
          url: 'https://route.cit.api.here.com/'
        }.tap do |options|
          options[:url] = 'https://route.api.here.com/' if production == true
        end
      end

      def parse_route_time(response)
        if response[:response]
          value = response.dig(:response, :route, 0, :leg, 0, :travelTime).to_i
          DriveInfo::Response.new(value)
        elsif response[:type]
          error = response.dig(:type)
          message = response.dig(:details)
          DriveInfo::Response.new(nil, error: error, error_message: message)
        else
          DriveInfo::Response.new(nil, error: 'UNKNOWN')
        end
      end
    end
  end
end
