require 'spec_helper'
require 'multi_xml'

describe AmazonPa::Attributes do
  before do
    @fix = "missing_parameter_error.xml"
    @client = AmazonPa::Client.new(access_key: 'AK', secret_key: 'SK', tracking_id: 'TI')
    
    stub_get.with(:query => signed_params({operation: 'ItemSearch', keywords: 'perl'})).to_return(:body => fixture(@fix), :headers => {:content_type => "application/xml; charset=utf-8"})
    stub_get.with(:query => signed_params({operation: 'ItemSearch', keywords: 'ruby'})).to_return(:body => fixture("item_search.xml"), :headers => {:content_type => "application/xml; charset=utf-8"})
    
    @response = @client.item_search(keywords: 'perl')
  end

  context "api response" do
    it "returns Atrributes class" do
      expect(@response).to be_a AmazonPa::Attributes
    end

    describe "#body" do
      it "returns raw response body" do 
        expect(@response.body).to eq fixture(@fix).read
        expect(@response.xml).to eq fixture(@fix).read
      end
    end

    describe "#to_hash" do
      it "returns hash" do
        xml = MultiXml.parse(fixture(@fix))
        expect(@response.to_hash).to eq xml
      end
    end

    describe "#define_attribute_methods" do
      it "returns false not defined method" do
        expect{@response.undefined_method}.to raise_error (NoMethodError)
      end

      it "returns correct value defined method" do
        expect(@response.respond_to?(:item_search_error_response)).to be_true
      end

      it "returns AmazonPa::Attribute" do
        expect(@response.item_search_error_response).to be_a AmazonPa::Attributes
      end

      it "returns string value" do
        expect(@response.item_search_error_response.error.code).to eq "MissingParameter"
      end

      it "returns #__context__ value" do
        response = @client.item_search(operation: 'ItemSearch', keywords: 'ruby')
        expect(response.item_search_response.items.item.first.small_image.height.__content__).to eq "75"
      end
    end
  end
end
