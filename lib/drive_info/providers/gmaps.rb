# frozen_string_literal: true

module DriveInfo
  module Providers
    class Gmaps < Base
      def route_time(options)
        response = route_time_request(options)
        parse_response(response)
      end

      def batch_route_time(requests)
        result = []
        connection.in_parallel do
          requests.each { |options| result.push route_time_request(options) }
        end
        result.map { |r| parse_response(r) }
      end

      def ignored_cache_params
        []
      end

      private

      def route_time_request(options)
        from        = options.fetch(:from)
        to          = options.fetch(:to)
        depart_time = options.fetch(:depart_time, Time.now)
        traffic_model = options.fetch(:traffic_model, :best_guess)
        mode = options.fetch(:mode, :driving)

        request('directions/json',
          origin: convert_point(from),
          destination: convert_point(to),
          arrival_time: depart_time.to_i,
          departure_time: depart_time.to_i,
          traffic_model: traffic_model,
          mode: mode,
          key: provider_options.fetch(:key, nil)
        )
      end

      def convert_point(point)
        return point if point.is_a?(String)
        return point_from_array(point) if point.is_a?(Array)
      end

      def point_from_array(point)
        point.join(',').delete(' ')
      end

      def request(url, params)
        log(:info, 'requesting', url, params)
        connection.get(url, params)
      end

      def parse_response(data)
        response = data.body
        case response.fetch(:status)
        when 'OK'
          response.dig(:routes, 0, :legs, 0, :duration, :value).to_i
        when 'NOT_FOUND'
          nil
        else
          fail response.fetch(:error_message)
        end
      end

      def base_url
        'https://maps.googleapis.com/maps/api/'
      end
    end
  end
end
