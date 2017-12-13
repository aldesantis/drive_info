# frozen_string_literal: true

module DriveInfo
  module Apis
    class RouteTime
      attr_reader :from, :to, :depart_time, :options, :response

      def initialize(options)
        @from = options[:from]
        @to = options[:to]
        @depart_time = options[:depart_time]
        @options = options.reject do |k, _|
          %i[from to depart_time].include?(k)
        end
        validate_context
      end

      def self.request(args)
        new(args).request
      end

      def request
        fail 'needs implementation'
      end

      protected

      def validate_context
        fail ArgumentError, 'from is required' unless from
        fail ArgumentError, 'to is required' unless to
        fail ArgumentError, 'depart_time is required' unless depart_time
      end

      def connection
        DriveInfo.connection
      end
    end
  end
end
