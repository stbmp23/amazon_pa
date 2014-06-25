require 'amazon_pa/error/client_error'

module AmazonPa
  class Error
    class Unauthorized < AmazonPa::Error::ClientError
      HTTP_STATUS_CODE = 401
    end
  end
end
