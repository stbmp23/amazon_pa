require 'amazon_pa/inflections'
require 'amazon_pa/error/arguments_error'

module AmazonPa
  module API
    class Arguments
      include AmazonPa::Inflections

      def initialize(*keys)
        @options = {}
        attrs = keys.last.is_a?(::Array) ? keys.pop : []
        attrs.each{|attr| attr_accessor(attr) }
      end

      def configure(params={}, &block)
        yield self if block_given?

        case params
        when Hash
          params.each do |key, value|
            raise AmazonPa::Error::ArgumentsError.new("Undefined option #{key}") unless respond_to?("#{key}=")
            send("#{key}=", value)
          end
        else
          raise AmazonPa::Error::ArgumentsError.new("Use Hash to set options")
        end
      end

      def options
        Hash[@options.map{|k, v| [camelize("#{k}"), v] }]
      end

      def options?
        options.any?
      end

    private

      def attr_accessor(*attrs)
        mod = Module.new do
          attrs.each do |attribute|
            define_method "#{attribute}" do
              instance_variable_get(:"@#{attribute}")
            end unless respond_to?(attribute)
            define_method "#{attribute}=" do |value|
              instance_variable_set(:"@#{attribute}", value)
              @options[attribute.to_sym] = value
            end unless respond_to?("#{attribute}=")
          end
        end
        extend mod
      end
    end
  end
end
