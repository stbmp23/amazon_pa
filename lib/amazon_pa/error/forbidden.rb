require 'amazon_pa/error/client_error'

module AmazonPa
  class Error
    class Forbidden < AmazonPa::Error::ClientError
      HTTP_STATUS_CODE = 403
    end
  end
end
