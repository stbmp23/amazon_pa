require 'amazon_pa/error/server_error'

module AmazonPa
  class Error
    class GatewayTimeout < AmazonPa::Error::ServerError
      HTTP_STATUS_CODE = 504
      MESSAGE = "The Amazon servers are up, Try again later."
    end
  end
end
