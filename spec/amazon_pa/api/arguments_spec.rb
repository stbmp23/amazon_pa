require 'spec_helper'

describe AmazonPa::API::Arguments do
  before do
    @keys = { keywords: 'ruby', country: 'ja' }
  end

  describe "#initialize" do
    it "add attribute methods" do
      arguments = AmazonPa::API::Arguments.new(@keys.keys)
      @keys.each do |key, value|
        expect(arguments.respond_to?(key)).to be_truthy
        expect(arguments.respond_to?("#{key}=")).to be_truthy
      end
    end

    it "sets attributes" do
      arguments = AmazonPa::API::Arguments.new(@keys.keys)
      @keys.each do |key, value|
        arguments.send("#{key}=", value)
        expect(arguments.send(key)).to eq value
      end
    end
  end

  describe "#attr_accessor" do
    it "add attribute methods" do
      arguments = AmazonPa::API::Arguments.new
      @keys.each do |key, value|
        arguments.send(:attr_accessor, key)
      end
      @keys.each do |key, value|
        expect(arguments.respond_to?(key)).to be_truthy
        expect(arguments.respond_to?("#{key}=")).to be_truthy
      end
    end
  end

  describe "#configure" do
    it "sets configuration to hash" do
      arguments = AmazonPa::API::Arguments.new(@keys.keys)
      arguments.configure(@keys)
      @keys.each do |key, value|
        expect(arguments.send(key)).to eq value
      end
    end

    it "sets configuration to block" do
      arguments = AmazonPa::API::Arguments.new(@keys.keys)
      @keys.each do |key, value|
        arguments.configure do |params|
          params.send("#{key}=", value)
        end
      end
      @keys.each do |key, value|
        expect(arguments.send(key)).to eq value
      end
    end

    it "raise argument error to use not defined attribute" do
      arguments = AmazonPa::API::Arguments.new(@keys.keys)
      expect{
        arguments.configure(not_defined_method: "value")
      }.to raise_error(AmazonPa::Error::ArgumentsError)
    end

    it "raise argument error not to use Hash" do
      arguments = AmazonPa::API::Arguments.new(@keys.keys)
      expect {
        arguments.configure(["keywords", "ruby"])
      }.to raise_error(AmazonPa::Error::ArgumentsError)
    end
  end

  describe "#options?" do
    it "returns true" do
      arguments = AmazonPa::API::Arguments.new(@keys.keys)
      arguments.configure({:keywords => 'ruby'})
      expect(arguments.options?).to be_truthy
    end

    it "returns false" do
      arguments = AmazonPa::API::Arguments.new(@keys.keys)
      expect(arguments.options?).to be_falsey
    end
  end
end
