# DriveInfo

DriveInfo allows you to get drive ETA between 2 locations.
Its supports multiple providers and cache mechanism.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'drive_info'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install drive_info

## Usage

```ruby
di = DriveInfo.new(
  provider: :gmaps
)

di.route_time(
  from: 'from address',
  to: 'to address',
  starting_at: Time.now
)
#=> 23123 (seconds)
```

## Providers

It allows to setup multiple providers, the default one is

Google Maps

If you want to create a custom provider you just need to:

```ruby
# frozen_string_literal: true

module DriveInfo
  module Providers
    class MyCustomProvider < Base
      def route_time(options)
        from        = options.fetch(:from)
        to          = options.fetch(:to)
        depart_time = options.fetch(:depart_time, Time.now)

        my_custom_api_key = options.fetch(:api_key, nil)

        connection.get(url, { from: from, to: to, start_time: depart_time }).body
      end

      ## Used for cache system to ignore query params on the request
      def ignored_cache_params
        ['depart_time']
      end

      private

      def base_url
        'https://myserviceapi/'
      end
    end
  end
end

require 'my_custom_provider'

DriveInfo.new(provider: :my_custom_provider, provider_options: {
  api_key: 'test_key'
})

```

## Cache

It allows to setup multiple cache system, the default one is

Redis

If you want to use a different one:

```ruby
# frozen_string_literal: true

class MyCustomCache
  attr_reader :store

  def initialize(options = {})
    @store = {}
  end

  def write(key, value)
    store[key] = value
  end

  def read(key)
    store[key]
  end
end

require 'my_custom_cache'

DriveInfo.new(provider: :my_custom_provider, cache: MyCustomCache.new)

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/drive_info.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
