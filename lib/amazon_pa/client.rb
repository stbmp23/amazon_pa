require 'faraday'
require 'multi_xml'
require 'amazon_pa/configurable'
require 'amazon_pa/api/item_search'
require 'amazon_pa/error/client_error'
require 'openssl'
require 'uri'

module AmazonPa
  class Client
    include AmazonPa::API::ItemSearch
    include AmazonPa::Configurable

    def initialize(options={})
      AmazonPa::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || AmazonPa.instance_variable_get(:"@#{key}"))
      end
    end

    # HTTP GET request
    def get(params={})
      request(:get, "", params)
    end

    # HTTP POST request
    # def post(path, params={})
    #   request(:post, path, params)
    # end

  private

    # def request_setup(method, path, params, signagure_params)
    #   Proc.new do |request|
    #   end
    # end

    def request(method, path, params={}, signature_params=params)
      # request_setup = request_setup(method, path, params, signature_params)
      # connection.send(method.to_sym, path, signed_parameters).env
      connection.send(method.to_sym, path, signed_parameters(params)).env
    rescue Faraday::Error::ClientError
      raise AmazonPa::Error::ClientError
    end

    def connection
      @connection ||= Faraday.new(@endpoint, @connection_options.merge(:builder => @middleware))
    end

    def signed_parameters(options={})
      @request_options = options
      Hash[request_parameters.map{|k, v| [k, v] }].merge({'Signature' => signature})
    end

    def request_parameters
      @request_options ||= {}

      {
        'Service' => self.service,
        'AWSAccessKeyId' => @access_key,
        'AssociateTag' => @tracking_id,
        'Version' => self.version,
        'Timestamp' => Time.iso8601(Time.now.xmlschema).iso8601,
      }.merge(@request_options)
    end

    def singed_request
      query = request_parameters.sort.map{|k, v| "#{k}=" + escape(v.to_s) }.join("&")
      uri = URI.parse(self.endpoint)
      ["GET", uri.host, uri.path, query].join("\n")
    end

    def signature
      hmac = OpenSSL::HMAC.digest('sha256', @secret_key, singed_request)
      #escape([hmac].pack('m').chomp)
      [hmac].pack('m').chomp
    end

    # URL-encode a string
    def escape(string)
      string.gsub(/([^a-zA-Z0-9_.~-]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end
    end
  end
end
