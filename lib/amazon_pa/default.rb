require 'faraday'
require 'faraday/request/multipart'
require 'amazon_pa/configurable'
require 'amazon_pa/error/client_error'
require 'amazon_pa/error/server_error'
require 'amazon_pa/response/parse_xml'
require 'amazon_pa/response/raise_error'

module AmazonPa
  module Default
    ENDPOINT = 'http://ecs.amazonaws.jp/onca/xml' unless defined? AmazonPa::Default::ENDPOINT
    SERVICE = 'AWSECommerceService' unless defined? AmazonPa::Default::SERVICE
    VERSION = '2013-08-01' unless defined? AmazonPa::Default::VERSION
    CONNECTION_OPTIONS = {
      :headers => {
        :accept => 'application/xml',
        :user_agent => "AmazonPa Ruby Gem #{AmazonPa::VERSION}",
      },
      :request => {
        :open_timeout => 5,
        :timeout => 10,
      }
    }
    MIDDLEWARE = Faraday::RackBuilder.new do |builder|
      #builder.response :logger
      # builder.use Faraday::Request::Multipart
      builder.use Faraday::Request::UrlEncoded
      # Handle 4xx server responses
      builder.use AmazonPa::Response::RaiseError, AmazonPa::Error::ClientError
      # Parse XML response bodies using MultiXml
      builder.use AmazonPa::Response::ParseXml
      # Handle 5xx server responses
      builder.use AmazonPa::Response::RaiseError, AmazonPa::Error::ServerError
      builder.adapter Faraday.default_adapter
    end unless defined? AmazonPa::Default::MIDDLEWARE

    class << self
      def options
        Hash[AmazonPa::Configurable.keys.map{|key| [key, send(key)]}]
      end

      def access_key
        ENV['ACCESS_KEY']
      end

      def secret_key
        ENV['SECRET_KEY']
      end

      def tracking_id
        ENV['TRACKING_ID']
      end

      def endpoint
        ENDPOINT
      end

      def service
        SERVICE
      end

      def version
        VERSION
      end

      def connection_options
        CONNECTION_OPTIONS
      end

      def middleware
        MIDDLEWARE
      end
    end
  end
end
