# Rspec::Custom

Shared matchers for use across projects

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-custom'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rspec-custom

## Usage

In your spec_helper.rb file:

```ruby
  # To include all enhancements
  require "rspec/custom/all"
```

or

```ruby
  # To pick and choose which enhancements you would like:
  require "rspec/custom/shared_examples/controllers"
  require "rspec/custom/matchers/views/json"
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
