require "coveralls"
Coveralls.wear!

require 'simplecov'
SimpleCov.start

require 'amazon_pa'

require 'openssl'
require 'timecop'
require 'webmock/rspec'

WebMock.disable_net_connect!

RSpec.configure do |config|
end

def escape(string)
  string.gsub(/([^a-zA-Z0-9_.~-]+)/) do
    '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
  end
end

def camelize(term)
  string = term.to_s
  string = string.sub(/^[a-z\d]*/){ $&.capitalize }
  string.gsub(/(?:_|(\/))([a-z\d]*)/){ $2.capitalize }.gsub('/', '::')
end

def signed_params(options={})
  options = {
    'Service' => AmazonPa::Default::SERVICE,
    'AWSAccessKeyId' => 'AK',
    'AssociateTag' => 'TI',
    'Version' => AmazonPa::Default::VERSION,
    'Timestamp' => Time.iso8601(Time.now.xmlschema).iso8601,
  }.merge(Hash[options.map{|k, v| [camelize(k.to_s), v] }])

  query = options.sort.map{|k, v| "#{k}=" + escape(v) }.join("&")
  uri = URI.parse(AmazonPa::Default::ENDPOINT)
  header = ["GET", uri.host, uri.path, query].join("\n")

  hmac = OpenSSL::HMAC.digest('sha256', 'SK', header)
  token = [hmac].pack('m').chomp

  Hash[options.map{|k, v| [k, v] }].merge('Signature' => token)
end

def baseurl
  AmazonPa::Default::ENDPOINT
end

def a_delete(path = "")
  a_request(:delete, baseurl + path)
end

def a_get(path = "")
  a_request(:get, baseurl + path)
end

def a_post(path = "")
  a_request(:post, baseurl + path)
end

def a_put(path = "")
  a_request(:put, baseurl + path)
end

def stub_delete(path = "")
  stub_request(:delete, baseurl + path)
end

def stub_get(path = "")
  stub_request(:get, baseurl + path)
end

def stub_post(path = "")
  stub_request(:post, baseurl + path)
end

def stub_put(path = "")
  stub_request(:put, baseurl + path)
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end
