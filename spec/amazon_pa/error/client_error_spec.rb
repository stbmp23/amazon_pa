require 'spec_helper'

describe AmazonPa::Error::ClientError do
  before do
    @client = AmazonPa::Client.new(access_key: 'AK', secret_key: 'SK', tracking_id: 'TI')
  end

  AmazonPa::Error::ClientError.errors.each do |status, exception|
    [nil, fixture("missing_parameter_error.xml")].each do |body|
      context "when HTTP status id #{status} and body is #{body.inspect}" do
        before do
          body_message = body unless body.nil?
          stub_get.with(:query => signed_params(operation: 'ItemSearch', keywords: 'ruby')).to_return(:status => status, :body => body_message)
        end
        it "raises #{exception.name}" do
          expect{@client.item_search(operation: 'ItemSearch', keywords: 'ruby')}.to raise_error exception
        end
      end
    end
  end
end
