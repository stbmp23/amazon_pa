require 'amazon_pa/error/server_error'

module AmazonPa
  class Error
    class BadGateway < AmazonPa::Error::ServerError
      HTTP_STATUS_CODE = 502
      MESSAGE = "AmazonAws is down or being updated."
    end
  end
end
