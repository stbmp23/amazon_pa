require 'spec_helper'

describe AmazonPa do
  after do
    AmazonPa.reset!
  end

  describe ".client" do
    it "returns a AmazonPa::Client" do
      expect(AmazonPa.client).to be_a AmazonPa::Client
    end

    context "when the options don't change" do
      it "changes the client" do
        expect(AmazonPa.client).to eq AmazonPa.client
      end
    end

    context "when the options change" do
      it "busts the cache" do
        client1 = AmazonPa.client
        AmazonPa.configure do |config|
          config.access_key = 'abc'
          config.secret_key = '123'
        end
        client2 = AmazonPa.client
        expect(client1).not_to eq client2
      end
    end
  end

  describe ".configure" do
    AmazonPa::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        AmazonPa.configure do |config|
          config.send("#{key}=", key)
        end
        expect(AmazonPa.instance_variable_get(:"@#{key}")).to eq key
      end
    end

    context "when invalid credentials are provided" do
      it "raise a ConfigurationError exception" do
        expect {
          AmazonPa.configure do |config|
            config.access_key = ['abc', 'xyz']
            config.secret_key = 'valid'
          end
        }.to raise_exception(AmazonPa::Error::ConfigurationError)
      end
    end

    context "when no credentials are provided" do
      it "does not raise an exception" do
        expect {
          AmazonPa.configure do |config|
            config.access_key = nil
            config.secret_key = nil
            config.tracking_id = nil
          end
        }.not_to raise_error
      end
    end
  end

  describe ".credentials?" do
    it "returns true if all credentials are present" do
      AmazonPa.configure do |config|
        config.access_key = 'AK'
        config.secret_key = 'SK'
        config.tracking_id = 'TI'
      end
      expect(AmazonPa.credentials?).to be_truthy
    end

    it "returns false if any credentials are missing" do
      AmazonPa.configure do |config|
        config.access_key = 'AK'
      end
      expect(AmazonPa.credentials?).to be_falsey
    end
  end
end
