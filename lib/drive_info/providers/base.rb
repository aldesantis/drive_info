# frozen_string_literal: true

module DriveInfo
  module Providers
    class Base
      attr_reader :base, :provider_options

      def initialize(base, provider_options = {})
        @base = base
        @provider_options = provider_options
      end

      def route_time(_)
        fail 'Not implemented'
      end

      def ignored_cache_params
        fail 'Not implemented'
      end

      private

      def connection
        @connection ||= Faraday.new(url: base_url) do |faraday|
          faraday.response :json, content_type: /\bjson$/, parser_options: { symbolize_names: true }
          faraday.request  :url_encoded
          if base.cache
            faraday.response :caching, ignore_params: ignored_cache_params do
              base.cache
            end
          end
          faraday.response :encoding
          faraday.adapter Faraday.default_adapter
        end
      end
    end
  end
end
