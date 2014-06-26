require 'amazon_pa/api/utils'

module AmazonPa
  module API
    module ItemLookup
      include AmazonPa::API::Utils
      OPERATION = 'ItemLookup'
      REQUEST_KEYS = [
        :operation,
        :condition,
        :id_type,
        :item_id,
        :merchant_id,
        :offer_page,
        :related_items_page,
        :relationship_type,
        :review_page,
        :review_sort,
        :search_index,
        :tag_page,
        :tags_per_page,
        :tag_sort,
        :variation_page,
        :response_group
      ]

      def item_lookup(options={}, &block)
        @item_lookup ||= AmazonPa::API::Arguments.new(REQUEST_KEYS)
        objects_from_response(:get, @item_lookup, option_params(options, OPERATION), &block)
      end
    end
  end
end
