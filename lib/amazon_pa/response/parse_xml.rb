require 'faraday'
require 'multi_xml'

module AmazonPa
  module Response
    class ParseXml < Faraday::Response::Middleware

      def parse(body)
        if body.nil?
          nil
        else
          MultiXml.parse(body)
        end
      end

      def on_complete(env)
        if respond_to?(:parse)
          env[:parse_body] = parse(env[:body]) unless [204, 301, 302, 304, 400].include?(env[:status])
        end
      end
    end
  end
end
