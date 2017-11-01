# frozen_string_literal: true

module DriveInfo
  module Providers
    class Gmaps < Base
      def route_time(options)
        from        = options.fetch(:from)
        to          = options.fetch(:to)
        depart_time = options.fetch(:depart_time, Time.now)
        traffic_model = options.fetch(:traffic_model, :best_guess)
        mode = options.fetch(:mode, :driving)

        response = request('directions/json',
          origin: from,
          destination: to,
          departure_time: depart_time.to_i,
          traffic_model: traffic_model,
          mode: mode,
          key: options.fetch(:key, nil)
        )
        parse_response(response)
      end

      def ignored_cache_params
        []
      end

      private

      def request(url, params)
        connection.get(url, params).body
      end

      def parse_response(response)
        case response.fetch(:status)
        when 'OK'
          response.dig(:routes, 0, :legs, 0, :duration, :value).to_i
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
