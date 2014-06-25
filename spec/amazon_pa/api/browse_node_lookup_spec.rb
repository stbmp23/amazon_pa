require 'spec_helper'

describe AmazonPa::API::BrowseNodeLookup do
  before do
    Timecop.freeze(Time.local(2013, 11, 27, 0, 0, 0))
    @client = AmazonPa::Client.new(access_key: 'AK', secret_key: 'SK', tracking_id: 'TI')
  end

  after do
    Timecop.return
  end

  describe "#browse_node_lookup" do
    before do
      @params = { operation: 'BrowseNodeLookup', browse_node_id: "467278" }
      stub_get.with(:query => signed_params(@params))
        .to_return(:body => fixture("browse_node_lookup.xml"), :headers => {:content_type => "application/xml; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.browse_node_lookup(@params)
      expect(a_get.with(:query => signed_params(@params))).to have_been_made
    end

    context "request the correct resource" do
      before do
        stub_get.with(:query => { operation: 'BrowseNodeLookup', browse_node_id: "467278" })
          .to_return(:body => fixture("browse_node_lookup.xml"), :headers => {:content_type => "application/xml; charset=utf-8"})
        @resource = @client.browse_node_lookup do |params|
          params.browse_node_id = "467278"
        end
      end
      subject { @resource }

      it "returns xml" do
        expect(subject.xml).to eq fixture("browse_node_lookup.xml").read
      end
    end
  end
end
