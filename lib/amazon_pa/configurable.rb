require 'forwardable'
require 'amazon_pa/default'
require 'amazon_pa/error/configuration_error'

module AmazonPa
  module Configurable
    extend Forwardable
    attr_writer :access_key, :secret_key, :tracking_id
    attr_accessor :endpoint, :service, :version, :connection_options, :middleware
    def_delegator :options, :hash

    class << self
      def keys
        @keys ||= [
          :access_key,
          :secret_key,
          :tracking_id,
          :endpoint,
          :service,
          :version,
          :connection_options,
          :middleware,
        ]
      end
    end

    def configure
      yield self
      validate_credential_type!
      self
    end

    def reset!
      AmazonPa::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", AmazonPa::Default.options[key])
      end
    end
    alias setup reset!

    def credentials?
      credentials.values.all?
    end

  private

    def credentials
      {
        :access_key => @access_key,
        :secret_key => @secret_key,
        :tracking_id => @tracking_id,
      }
    end

    def options
      Hash[AmazonPa::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

    def validate_credential_type!
      credentials.each do |credential, value|
        next if value.nil?

        unless value.is_a?(String) || value.is_a?(Symbol)
          raise(Error::ConfigurationError, "Invalid #{credential} specified: #{value} must be a sting or symbol.")
        end
      end
    end
  end
end
