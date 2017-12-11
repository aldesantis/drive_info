# frozen_string_literal: true

require 'json'

module DriveInfo
  module Cache
    class Redis
      attr_reader :redis_url
      attr_reader :connection
      attr_reader :ttl

      def initialize(options = {})
        @redis_url = options[:redis_url] || ENV['REDIS_URL'] || 'redis://127.0.0.1:6379/0'
        @connection = options[:connection] || ::Redis.new(url: redis_url)
        @ttl = options[:ttl] || 20
      end

      def write(key, value)
        data = response_hash(value)
        connection.setex(key, ttl, JSON.generate(data))
      end

      def read(key)
        result = connection.get(key)

        return nil unless result

        result = JSON.parse(result)

        ::Faraday::Response.new(response_hash(result))
      end

      private

      def response_hash(env)
        hash = env.to_hash

        {
          status: (hash[:status] || hash['status']),
          body: (hash[:body] || hash['body']),
          response_headers: (hash[:response_headers] || hash['response_headers'])
        }
      end
    end
  end
end
