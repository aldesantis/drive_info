# frozen_string_literal: true

require 'drive_info/version'
require 'drive_info/client'
require 'drive_info/response'
require 'drive_info/apis/route_time'

module DriveInfo
  class DriveInfoError < StandardError; end

  @providers = {}
  @caches = {}

  class << self
    attr_accessor :provider
    attr_reader :cache
    attr_reader :providers
    attr_reader :caches
    attr_accessor :connection

    def configure
      yield self
      true
    end

    def register_provider(name, mod)
      @providers[name] = mod
    end

    def register_cache(name, mod)
      @caches[name] = mod
    end

    def use_provider(name)
      return false unless name
      return fail DriveInfoError, "Provider #{name} does not exist" unless providers[name]

      if block_given?
        old_provider = @provider
        begin
          @provider = providers[name]
          yield
        ensure
          @provider = old_provider
        end
      else
        @provider = providers[name]
      end
    end

    def use_cache(name)
      return false unless name
      return fail DriveInfoError, "Cache #{name} does not exist" unless caches[name]
      @cache = caches[name]
    end
  end
end

require 'drive_info/providers/gmaps'
require 'drive_info/cache/redis'
