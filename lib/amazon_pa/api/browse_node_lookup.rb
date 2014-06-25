require 'amazon_pa/api/utils'

module AmazonPa
  module API
    module BrowseNodeLookup
      include AmazonPa::API::Utils
      OPERATION = 'BrowseNodeLookup'
      REQUEST_KEYS = [
        :operation,
        :browse_node_id,
        :response_group
      ]

      def browse_node_lookup(options={}, &block)
        @browse_node_lookup ||= AmazonPa::API::Arguments.new(REQUEST_KEYS)
        objects_from_response(:get, @browse_node_lookup, option_params(options, OPERATION), &block)
      end
    end
  end
end
