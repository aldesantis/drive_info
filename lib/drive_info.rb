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
require 'typhoeus'
require 'typhoeus/adapters/faraday'

# Drive travel information library
#
# di = DriveInfo.new(provider: :gmaps, key: 'XXXX')
# di.route_time(from: 'FROM ADDRESS', to: 'TO ADDRESS', starting_at: Time)
module DriveInfo
  class << self
    attr_accessor :provider
    attr_accessor :provider_options
    attr_accessor :cache
    attr_accessor :debug

    def new(options = {})
      config = default_configuration.merge(options)
      Base.new(config)
    end

    def configure
      yield self
      true
    end

    private

    def default_configuration
      {
        provider: provider || :gmaps,
        provider_options: provider_options || {},
        cache: cache,
        debug: debug || false
      }
    end
  end
end
