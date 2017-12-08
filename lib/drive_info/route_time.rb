# frozen_string_literal: true

module DriveInfo
  class Base
    def route_time(options)
      adapter.route_time(options)
    end

    def batch_route_time(options)
      adapter.batch_route_time(options)
    end
  end
end
