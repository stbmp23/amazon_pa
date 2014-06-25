require 'faraday'
require 'amazon_pa/error/bad_gateway'
require 'amazon_pa/error/bad_request'
require 'amazon_pa/error/forbidden'
require 'amazon_pa/error/gateway_timeout'
require 'amazon_pa/error/not_acceptable'
require 'amazon_pa/error/not_found'
require 'amazon_pa/error/service_unavailable'
require 'amazon_pa/error/unauthorized'
require 'amazon_pa/error/internal_server_error'

module AmazonPa
  module Response
    class RaiseError < Faraday::Response::Middleware
      def on_complete(env)
        status_code = env[:status].to_i
        error_class = @klass.errors[status_code]
        raise error_class.from_response(env) if error_class
      end

      def initialize(app, klass)
        @klass = klass
        super(app)
      end
    end
  end
end
