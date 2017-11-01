# frozen_string_literal: true

require 'faraday'
require 'redis'
require 'logger'
require 'faraday-encoding'
require 'faraday_middleware'
require 'drive_info/version'
require 'drive_info/base'
require 'drive_info/route_time'
require 'drive_info/cache/redis'
require 'drive_info/providers/base'
require 'drive_info/providers/gmaps'

# Drive travel information library
#
# di = DriveInfo.new(provider: :gmaps, key: 'XXXX')
# di.route_time(from: 'FROM ADDRESS', to: 'TO ADDRESS', starting_at: Time)
module DriveInfo
  class << self
    def new(options = {})
      Base.new(default_configuration.merge(options))
    end

    private

    def default_configuration
      {
        provider: :gmaps,
        provider_options: {},
        cache: Cache::Redis.new,
        debug: false
      }
    end
  end
end
