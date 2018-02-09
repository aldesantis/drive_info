# frozen_string_literal: true

module DriveInfo
  module Providers
    require_relative 'gmaps/route_time'

    class Gmaps
      BASE_URL = 'https://maps.googleapis.com/maps/api'

      attr_reader :key

      def initialize(options = {})
        @key = options[:key]
      end

      def route_time(options)
        RouteTime.request(options.merge(options_data))
      end

      def parse(method, response)
        obj = case method.to_sym
        when :route_time
          parse_route_time(response)
        else
          fail "Invalid method for parsing #{method}"
        end
        obj.raw = response
        obj
      end

      private

      def options_data
        {
          key: key
        }
      end

      def parse_route_time(response)
        case response.fetch(:status, nil)
        when 'OK'
          value = response.dig(:routes, 0, :legs, 0, :duration_in_traffic, :value).to_i
          DriveInfo::Response.new(value)
        when 'NOT_FOUND'
          DriveInfo::Response.new(nil, error: 'NOT_FOUND')
        else
          DriveInfo::Response.new(nil, error: 'UNKNOWN')
        end
      end
    end
  end
end
