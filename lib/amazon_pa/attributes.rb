require 'multi_xml'
require 'amazon_pa/inflections'

module AmazonPa
  class Attributes
    include AmazonPa::Inflections
    attr_reader :to_hash, :body
    alias :xml :body

    # @param response_hash [Faraday::Resopnse.env[:parse_body]]
    # @param response_xml [Faraday::Response.env[:body]]
    def initialize(response_hash, response_xml=nil)
      @to_hash = response_hash
      @body = response_xml if response_xml
      define_attribute_methods
    end

    # Get Attributes class use xpath
    #
    # response = AmazonPa.client.item_search(keywords: 'ruby')
    # response.path("ItemSearchResponse/Items/Item").first.small_image.height  #=> "75"
    # def path(path)
    #   klass = self
    #   path.split("/").each do |path|
    #     method_name = underscore(path)
    #     klass = klass.send(method_name)
    #   end
    #   klass
    # end

    # @param path [String] XPATH
    # @param parser[Symbol] Set the XML sutilizing a symbol.
    # def xpath(path, parser=nil)
    # end

  private

    # unless respond_to?, generates the attribute methods
    # def respond_to_missing?(method_name, include_private=false)
    #   define_attribute_methods
    #   generated_methods.include?(method_name)
    # end

    # Generates the attribute related methods
    def define_attribute_methods
      unless generated_methods?
        @to_hash.each do |key, attribute_hash|
          next unless attribute_hash
          attribute_xml = nil

          method_name = underscore(key)
          evaluate_attribute_method(method_name, attribute_hash, attribute_xml)
        end
        @is_generated_methods = true
      end
    end

    # Define attiribute method
    def evaluate_attribute_method(method_name, attribute_hash, attribute_xml=nil)
      case attribute_hash
      when Hash
        attribute = AmazonPa::Attributes.new(attribute_hash, attribute_xml)
      when Array
        attribute = attribute_hash.map do |attr|
          if attr.is_a?(Hash)
            AmazonPa::Attributes.new(attr, attribute_xml)
          else
             attr
          end
        end
      when String
        attribute = attribute_hash
        attribute = true if attribute =~ /^true$/i
        attribute = false if attribute =~ /^false$/i
      end

      mod = Module.new do
        define_method "#{method_name}" do
          attribute
        end
      end
      extend mod
      generated_methods << method_name
    end

    # @return [Array]
    def generated_methods
      @generated_methods ||= []
    end

    def generated_methods?
      !!@is_generated_methods
    end

    # def method_missing(method_name, *args, &block)
    #   return super unless respond_to?(method_name)
    #   send(method_name, *args, &block)
    # end
  end
end
