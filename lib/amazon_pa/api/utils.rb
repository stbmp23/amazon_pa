require 'amazon_pa/api/arguments'
require 'amazon_pa/attributes'

module AmazonPa
  module API
    module Utils

    private

      def objects_from_response(request_method, klass, options={}, &block)
        klass.configure(options, &block)
        response = send(request_method.to_sym, klass.options) if klass.options?
        AmazonPa::Attributes.new(response[:parse_body], response[:body])
      end

      def option_params(options={}, operation)
        options.merge(operation: operation)
      end

      # def object_from_response(request_method, path, options={})
      #   response = send(request_method.to_sym, path, options)
      #   resopnse
      # end
    end
  end
end
