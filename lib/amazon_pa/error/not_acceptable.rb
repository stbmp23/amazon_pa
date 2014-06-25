require 'amazon_pa/error/client_error'

module AmazonPa
  class Error
    class NotAcceptable < AmazonPa::Error::ClientError
      HTTP_STATUS_CODE = 406
    end
  end
end
