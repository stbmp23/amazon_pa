require 'amazon_pa/error'

module AmazonPa
  class Error
    class ServerError < AmazonPa::Error
      MESSAGE = "Server Error"

      def self.from_response(response={})
        new(parse_error(response[:body]), response[:response_headers])
      end

      def initialize(message=nil, response_headers={})
        super((message || self.class.const_get(:MESSAGE)), response_headers)
      end

    private

      def self.parse_error(body)
        begin
          if md = body.match(/<Error>.+<\/Error>/)
            xml = MultiXml.parse(md[0])
            "Error: #{xml['Error']['Code']}, #{xml['Error']['Message']}"
          end
        rescue
          nil
        end
      end
    end
  end
end
