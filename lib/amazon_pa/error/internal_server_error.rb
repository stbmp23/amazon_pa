require 'amazon_pa/error/server_error'

module AmazonPa
  class Error
    class InternalServerError < AmazonPa::Error::ServerError
      HTTP_STATUS_CODE = 500
      MESSAGE = "Someting went wrong."
    end
  end
end
