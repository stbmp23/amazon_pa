require 'amazon_pa/api/utils'

module AmazonPa
  module API
    module ItemSearch
      include AmazonPa::API::Utils
      OPERATION = 'ItemSearch'
      REQUEST_KEYS = [
        :operation,
        :actor,
        :artist,
        :audience_rating,
        :author,
        :availability,
        :brand,
        :browse_node,
        :city,
        :composer,
        :condition,
        :conductor,
        :item_page,
        :keywords,
        :manufacturer,
        :maximum_price,
        :merchant_id,
        :minimum_price,
        :neighborhood,
        :orchestra,
        :postal_code,
        :power,
        :publisher,
        :related_item_page,
        :ralationship_type,
        :review_sort,
        :search_index,
        :sort,
        :tag_page,
        :tags_per_page,
        :tag_sort,
        :text_stream,
        :title,
        :variation_page,
        :response_group
      ]

      def item_search(options={}, &block)
        @item_search ||= AmazonPa::API::Arguments.new(REQUEST_KEYS)
        objects_from_response(:get, @item_search, option_params(options, OPERATION), &block)
      end
    end
  end
end
