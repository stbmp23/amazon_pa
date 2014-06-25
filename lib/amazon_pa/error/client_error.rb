require 'amazon_pa/error'
require 'multi_xml'

module AmazonPa
  class Error
    class ClientError < AmazonPa::Error
      def self.from_response(response={})
        new(parse_error(response[:body]), response[:response_headers])
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
