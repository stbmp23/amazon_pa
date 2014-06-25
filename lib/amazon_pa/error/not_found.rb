require 'amazon_pa/error/client_error'

module AmazonPa
  class Error
    class NotFound < AmazonPa::Error::ClientError
      HTTP_STATUS_CODE = 404
    end
  end
end
