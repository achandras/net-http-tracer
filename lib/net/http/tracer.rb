require "net/http/tracer/version"

module Net
  module Http
    module Tracer

      class << self

        def instrument
          patch_request
        end

        def tracer_request?
          for location in caller_locations
            return true if location.label == 'send_spans'
          end
          return false
        end

        def patch_request

          ::Net::HTTP.module_eval do
            alias_method :request_original, :request

            def request(req, body = nil, &block)
              res = ''

              if ::Net::Http::Tracer.tracer_request?
                # this is probably a request to export spans, so we should ignore it
                res = request_original(req, body, &block)
              else
                tags = {
                  "component" => "Net::HTTP",
                  "span.kind" => "client",
                  "http.method" => req.method,
                  "http.url" => req.path,
                  "peer.host" => @address,
                  "peer.port" => @port,
                }
                OpenTracing.global_tracer.start_active_span("#{req.method} #{req.path}", tags: tags) do |scope|
                  # inject the trace so it's available to the remote service
                  OpenTracing.inject(scope.span.context, OpenTracing::FORMAT_RACK, req)

                  # call the original request method
                  res = request_original(req, body, &block)

                  # set response code and error if applicable
                  scope.span.set_tag("http.status_code", res.code)
                  scope.span.set_tag("error", true) if res.is_a?(::Net::HTTPClientError)
                end
              end

              res
            end
          end
        end
      end
    end
  end
end
