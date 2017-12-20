# DriveInfo

[![CircleCI status](https://img.shields.io/circleci/token/5be5c6631df2c658ca9c1425b0ebc448741aee2d/project/github/batteries911/drive_info/develop.svg?style=flat-square)](https://circleci.com/gh/batteries911/drive_info)
[![Codacy grade](https://img.shields.io/codacy/grade/871cbb52660d43c294dedcdf02113df4/develop.svg?style=flat-square)](https://www.codacy.com/app/Batteries911/drive_info/dashboard)
[![Codacy coverage](https://img.shields.io/codacy/coverage/871cbb52660d43c294dedcdf02113df4/develop.svg?style=flat-square)](https://www.codacy.com/app/Batteries911/drive_info/dashboard)

DriveInfo allows you to get drive ETA between 2 locations. 

It supports multiple providers and cache mechanism.

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
di = DriveInfo.new

di.register_provider(
  :gmaps,
  DriveInfo::Provider::Gmaps.new
)

di.use_provider(:gmaps)

call = di.route_time(
  from: 'from address',
  to: 'to address',
  depart_time: Time.now
)
=> #<DriveInfo::Response:0x00007fa1345ee1d8 @error=nil, @error_message=nil, @value=15905>

call.success?
=> true

call.value
=> 15905 (seconds)
```

## Providers

It allows to setup multiple providers and you can change them at runtime.

The gem provides a default provider which is Gmaps.

DriveInfo::Providers::Gmaps

If you want to create a custom provider you just need to:

```ruby
# frozen_string_literal: true

module DriveInfo
  module Providers
    class MyCustomProvider
      attr_reader :key

      def initialize(options = {})
        @key = options[:key]
      end

      def parse(method, response)
        # here you define the parsing logic for the method
        # specified

        if method == :route_time
          response.fetch(:value)
        end
      end

      def route_time(options)
        RouteTime.request(options.merge(key: key))
      end

      class RouteTime < ::DriveInfo::Apis::RouteTime
        def request
          # you have access to: from, to and depart_time

          my_custom_api_key = options.fetch(:api_key, nil)

          # you should return a Faraday::Request
          connection.get('my_custom_url', { from: from, to: to, start_time: depart_time })
        end
      end
    end
  end
end

require 'my_custom_provider'

DriveInfo.register_provider(:my_custom_provider,
  DriveInfo::Providers::MyCustomProvider.new(
    api_key: 'my_custom_api_key'
  )
)

DriveInfo.use_provider(:my_custom_provider)
```

## Cache

It allows to setup multiple cache system, the default one is

Redis (DriveInfo::Cache::Redis)

If you want to use a different one:

```ruby
# frozen_string_literal: true

class MyCustomCache
  attr_reader :store

  def initialize(options = {})
    @store = {}
  end

  # value: Faraday::Response
  def write(key, value)
    store[key] = value
  end

  # O: Faraday::Response
  def read(key)
    store[key]
  end
end

require 'my_custom_cache'

DriveInfo.register_cache(:my_custom_cache,
  MyCustomCache.new(
    other_options: {}
  )
)

DriveInfo.use_cache(:my_custom_cache)

```

## Batch Requests

Support for batch requests has been added on 1.0 version.

In order to make use of them just call your api's passing in a requests array.

Example

```ruby
  requests = [
    { from: 'from_location', to: 'to_location', depart_time: '' },
    { from: 'from_location', to: 'to_location', depart_time: '' }
  ]

  DriveInfo::Client.new.route_time(requests: requests)
  => [
    #<DriveInfo::Response:0x00007fa1345ee1d8 @error=nil, @error_message=nil, @value=15905>,
    #<DriveInfo::Response:0x00007fa1345ee1d2 @error=nil, @error_message=nil, @value=15905>
  ]
```

## Todos

- [ ] Better tests on parallel requests when requests fails

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/drive_info.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
