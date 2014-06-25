require 'amazon_pa/error/server_error'

module AmazonPa
  class Error
    class ServiceUnavailable < AmazonPa::Error::ServerError
      HTTP_STATUS_CODE = 503
      MESSAGE = "Too many requests to amazon server."
    end
  end
end
