# frozen_string_literal: true

module DriveInfo
  module Providers
    class Gmaps
      class RouteTime < ::DriveInfo::Apis::RouteTime
        def request
          connection.get(url,
            origin: convert_point(from),
            destination: convert_point(to),
            departure_time: depart_time.to_i,
            **custom_options
          )
        end

        private

        def custom_options
          {
            traffic_model: (options[:traffic_model] || :best_guess),
            mode: (options[:mode] || :driving),
            key: options[:key]
          }.compact
        end

        def url
          "#{Gmaps::BASE_URL}/directions/json"
        end

        def convert_point(point)
          return point if point.is_a?(String)
          return point_from_array(point) if point.is_a?(Array)
        end

        def point_from_array(point)
          point.join(',').delete(' ')
        end
      end
    end
  end
end
