require 'spec_helper'

describe AmazonPa::Client do
  subject do
    AmazonPa::Client.new(:access_key => 'AK', :secret_key => 'SK', :tracking_id => 'TI')
  end

  context "with module configuration" do
    before do
      AmazonPa.configure do |config|
        AmazonPa::Configurable.keys.each do |key|
          config.send("#{key}=", key)
        end
      end
    end

    after do
      AmazonPa.reset!
    end

    it "inherits the module configuration" do
      client = AmazonPa::Client.new
      AmazonPa::Configurable.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq key
      end
    end

    context "with class configuration" do
      before do
        @configuration = {
          :access_key => 'AK',
          :secret_key => 'SK',
          :tracking_id => 'TI',
          :endpoint => 'http://example.com/test',
          :service => 'S',
          :version => '2013-08-01',
          :connection_options => ::Hash,
          :middleware => Proc.new{},
        }
      end

      context "during initialization" do
        it "overrides the module configuration" do
          client = AmazonPa::Client.new(@configuration)
          AmazonPa::Configurable.keys.each do |key|
            expect(client.instance_variable_get(:"@#{key}")).to eq @configuration[key]
          end
        end
      end

      context "after initialization" do
        it "overrides the module configuraton after initialization" do
          client = AmazonPa::Client.new
          client.configure do |config|
            @configuration.each do |key, value|
              config.send("#{key}=", value)
            end
          end
          AmazonPa::Configurable.keys.each do |key|
            expect(client.instance_variable_get(:"@#{key}")).to eq @configuration[key]
          end
        end
      end
    end
  end

  describe "#credentials?" do
    it "returns true if all credentials are present" do
      client = AmazonPa::Client.new(:access_key => 'AK', :secret_key => 'SK', :tracking_id => 'TI')
      expect(client.credentials?).to be_truthy
    end

    it "returns false if any credentials are missing" do
      client = AmazonPa::Client.new(:access_key => 'AK', :secret_key => 'SK')
      expect(client.credentials?).to be_falsey
    end
  end

  describe "#connection" do
    it "looks like Faraday connection" do
      expect(subject.send(:connection)).to respond_to(:run_request)
    end

    it "memorized the connection" do
      c1, c2 = subject.send(:connection), subject.send(:connection)
      expect(c1.object_id).to eq c2.object_id
    end
  end

  describe "#request" do
    it "catches Faraday errors" do
      allow(subject).to receive(:connection).and_raise(Faraday::Error::ClientError.new("Oops"))
      expect{subject.send(:request, :get, "/path")}.to raise_error AmazonPa::Error::ClientError
    end
  end

  describe "#signature" do
    before do
      Timecop.travel(Time.local(2013, 11, 27, 0, 0, 0))
    end

    it "returns signature for amazon api" do
      expect(subject.send(:signature)).to eq "WU+GJX6Y5eKnxtCL2k+EhaV7WsWBAEmfpRL6GCnkeT8="
    end
  end

  describe "#signed_parameters" do
    before do
      Timecop.travel(Time.local(2013, 11, 27, 0, 0, 0))
    end

    it "returns request hash contained signature" do
      signed_params = {
        'Service' => AmazonPa::Default::SERVICE,
        'AWSAccessKeyId' => subject.instance_variable_get(:"@access_key"),
        'AssociateTag' => subject.instance_variable_get(:"@tracking_id"),
        'Version' => AmazonPa::Default::VERSION,
        'Timestamp' => '2013-11-26T15:00:00Z',
        'Keywords' => 'ruby',
        'Signature' => 'toZ87CXhNU10Ca+ZoccHKBREoB2opfY3UqA27VzPwNE=',
      }

      expect(subject.send(:signed_parameters, {'Keywords' => 'ruby'})).to eq signed_params
    end
  end
end
