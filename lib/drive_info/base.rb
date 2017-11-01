# frozen_string_literal: true

module DriveInfo
  class Base
    attr_reader :provider, :cache, :provider_options

    def initialize(options = {})
      @provider = options.fetch(:provider, nil)
      @cache    = options.fetch(:cache, nil)
      @provider_options = options.fetch(:provider_options, {})
    end

    private

    def adapter
      klass = Object.const_get("::DriveInfo::Providers::#{provider.to_s.capitalize}")
      klass.new(self, provider_options)
    end
  end
end
