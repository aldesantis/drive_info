# frozen_string_literal: true

module DriveInfo
  module Providers
    class Here
      class RouteTime < ::DriveInfo::Apis::RouteTime
        def request
          connection.get(url,
            waypoint0: convert_point(from),
            waypoint1: convert_point(to),
            departure: depart_time.iso8601,
            **custom_options
          )
        end

        private

        def custom_options
          {
            mode: 'fastest;car;traffic:enabled'
          }.merge(options).compact
        end

        def url
          "#{options[:url]}/routing/7.2/calculateroute.json"
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
