# Net::Http::Tracer

This gem automatically traces all requests made with Net::HTTP.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'net-http-tracer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install net-http-tracer

## Usage

Set an OpenTracing-compatible tracer, such as ['jaeger-client'](https://github.com/salemove/jaeger-client-ruby), as the global tracer.

Export an environment variable, `TRACER_INGEST_URL`, with the Jaeger span ingest URL. The tracer will ignore outgoing requests to this URL when tracing requests.

```bash
export TRACER_INGEST_URL='https://localhost:14268/api/traces'
```

If no URL is specified, the one above is used as the default.

Before making any requests, configure the tracer:

```ruby
require 'net/http/tracer'

Net::Http::Tracer.instrument
```

The spans will be given a name consisting of the HTTP method and request path.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/achandras/net-http-tracer.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
