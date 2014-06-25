require 'spec_helper'

describe AmazonPa::Error::ServerError do
  before do
    @client = AmazonPa::Client.new(access_key: 'AK', secret_key: 'SK', tracking_id: 'TI')
  end

  AmazonPa::Error::ServerError.errors.each do |status, exception|
    [nil, fixture("missing_parameter_error.xml")].each do |body|
    context "when HTTP status is #{status}" do
      before do
        stub_get.with(:query => signed_params(operation: 'ItemSearch', keywords: 'ruby')).to_return(:status => status, :body => body)
      end
      it "raises #{exception.name}" do
        expect{@client.item_search(operation: 'ItemSearch', keywords: 'ruby')}.to raise_error exception
      end
    end
    end
  end
end
