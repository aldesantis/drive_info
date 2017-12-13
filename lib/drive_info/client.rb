# frozen_string_literal: true

require 'faraday'
require 'redis'
require 'faraday-encoding'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

module DriveInfo
  class Client
    def initialize(**options)
      config = default_configuration.merge(options)

      DriveInfo.use_provider(config[:provider])
      DriveInfo.use_cache(config[:cache]) if config[:cache]
      DriveInfo.connection = config[:connection]
    end

    def provider
      DriveInfo.provider
    end

    def cache
      DriveInfo.cache
    end

    def connection
      DriveInfo.connection
    end

    def call(sym, args)
      if args[0][:requests]
        batch_requests(sym, *args)
          .map { |r| provider.parse(sym, r) }
      else
        response = request(sym, *args).body
        provider.parse(sym, response)
      end
    end

    def batch_requests(sym, args)
      result = []
      connection.in_parallel do
        (args[:requests] || []).each do |r|
          result.push(request(sym, r))
        end
      end
      result.map(&:body)
    end

    def request(sym, args)
      provider.send(sym, args)
    end

    private

    def default_configuration
      {
        provider: nil,
        connection: buid_connection,
        cache: nil
      }
    end

    def buid_connection
      @connection ||= Faraday.new do |faraday|
        faraday.response :json, content_type: /\bjson$/, parser_options: { symbolize_names: true }
        faraday.request  :url_encoded
        faraday.request :retry, max: 3, interval: 0.05, interval_randomness: 0.5
        if DriveInfo.cache
          faraday.response :caching do
            DriveInfo.cache
          end
        end
        faraday.response :encoding
        faraday.adapter :typhoeus
      end
    end

    def valid_operation?(name)
      return false unless provider
      provider.respond_to?(name)
    rescue NameError => _
      false
    end

    def method_missing(sym, *args)
      if valid_operation?(sym)
        call(sym, args)
      elsif DriveInfo.respond_to?(sym)
        DriveInfo.send(sym, *args)
      else
        fail 'Missing provider' unless provider
        super
      end
    end

    def respond_to_missing?(sym, _)
      valid_operation?(sym) || DriveInfo.respond_to?(sym)
    end
  end
end
