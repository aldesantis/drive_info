# frozen_string_literal: true

module DriveInfo
  class Response
    attr_reader :error, :error_message, :value

    def initialize(value, error: nil, error_message: nil)
      @value = value
      @error = error
      @error_message = error_message
    end

    def success?
      error.nil?
    end
  end
end
