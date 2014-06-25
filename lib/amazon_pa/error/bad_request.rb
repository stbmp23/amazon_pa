require 'amazon_pa/error/client_error'

module AmazonPa
  class Error
    class BadRequest < AmazonPa::Error::ClientError
      HTTP_STATUS_CODE = 400
    end
  end
end
