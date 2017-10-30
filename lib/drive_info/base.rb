# frozen_string_literal: true

module DriveInfo
  class Base
    attr_reader :provider, :key, :cache

    def initialize(options = {})
      @provider = options.fetch(:provider, nil)
      @key      = options.fetch(:key, nil)
      @cache    = options.fetch(:cache, nil)
    end

    private

    def adapter
      klass = Object.const_get("::DriveInfo::Providers::#{provider.to_s.capitalize}")
      klass.new(self)
    end
  end
end
