# frozen_string_literal: true

module DriveInfo
  module Cache
    class Redis
      attr_reader :redis_url
      attr_reader :connection
      attr_reader :ttl
      attr_reader :logger

      def initialize(options = {})
        @redis_url = options[:redis_url] || ENV['REDIS_URL'] || 'redis://127.0.0.1:6379/0'
        @connection = options[:connection] || ::Redis.new(url: redis_url)
        @ttl = options[:ttl] || 20
        @logger = Logger.new(STDOUT) if options.fetch(:debug, false)
      end

      def write(key, value)
        log(:info, 'cache:write', key, value)
        marshaled = JSON.generate(value.marshal_dump)
        connection.setex(key, ttl, marshaled)
      end

      def read(key)
        log(:info, 'cache:read', key)
        result = connection.get(key)

        unless result
          log(:info, 'cache:miss', key)
          return nil
        end

        parsed = JSON.parse(result)
        env = Faraday::Env.from(parsed)
        Faraday::Response.new(env)
      end

      private

      def log(type, *message)
        logger&.send(type, message)
      end
    end
  end
end
