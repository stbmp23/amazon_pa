require "amazon_pa/version"
require "amazon_pa/client"
require "amazon_pa/configurable"
require "amazon_pa/attributes"

module AmazonPa
  class << self
    include AmazonPa::Configurable

    def client(&block)
      @client = AmazonPa::Client.new(options) unless defined?(@client) && @client.hash == options.hash
      @client.configure(&block) if block_given?
      @client
    end
  end
end

AmazonPa.setup
