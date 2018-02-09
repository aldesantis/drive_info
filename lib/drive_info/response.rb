# frozen_string_literal: true

module DriveInfo
  class Response
    attr_reader :error, :error_message, :value
    attr_accessor :raw

    def initialize(value, error: nil, error_message: nil, raw: nil)
      @value = value
      @error = error
      @error_message = error_message
      @raw = raw
    end

    def success?
      error.nil?
    end
  end
end
