# AmazonPa [![Coverage Status](https://coveralls.io/repos/stbmp23/amazon_pa/badge.png)](https://coveralls.io/r/stbmp23/amazon_pa)

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'amazon_pa'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install amazon_pa

## Usage

Create api client

```ruby
client = AmazonPa.client do |conf|
  conf.access_key = 'your access key'
  conf.secret_key = 'your secret key'
  conf.tracking_id = 'your tracking id'
end
```

Get Response from Amazon Product API

```ruby
response = client.item_search(search_index: "Books", keywords: "ruby")
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
