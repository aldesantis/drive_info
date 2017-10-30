# frozen_string_literal: true

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
        marshaled = JSON.generate(value.marshal_dump)
        connection.setex(key, ttl, marshaled)
      end

      def read(key)
        result = connection.get(key)
        return nil unless result

        parsed = JSON.parse(result)
        env = Faraday::Env.from(parsed)
        Faraday::Response.new(env)
      end
    end
  end
end
