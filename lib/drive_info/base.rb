# frozen_string_literal: true

module DriveInfo
  class Base
    attr_reader :provider, :cache, :provider_options, :log

    def initialize(options = {})
      @provider = options.fetch(:provider, nil)
      @cache    = options.fetch(:cache, nil)
      @provider_options = options.fetch(:provider_options, {})
      @log = Logger.new(STDOUT) if options.fetch(:debug, false)
    end

    private

    def adapter
      klass = Object.const_get("::DriveInfo::Providers::#{provider_klass}")
      klass.new(self, provider_options)
    end

    def provider_klass
      provider.to_s.split('_').collect(&:capitalize).join
    end
  end
end
