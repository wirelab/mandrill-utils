# Papio

This gem provider a full mandrill based email system. It allows sending emails in bulk using mandrills' RESTfull API.
It is designed to feel like ActionMailer, however there are various notable differences.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'papio'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install papio

## Usage

You need to set the api_key and other config options.
```ruby
Papio.configure do |config|
  config.api_key = 'your_key_here'
  config.development = false # Setting this to true results in functionality much like letter_opener.
  config.temp_directory = Dir.tmpdir # optional; This is where files a rendered for development mode.
end
```

Next you create a mailer.
```ruby
class Mailer < Papio::Mailer
  default from: 'info@example.com', reply_to: 'reply@example.com'

  def some_mail
    @title = 'title'
    mail to: 'test@example.org', template: 'test-template'
  end
end
```

You can then send mails directly:
```ruby
Mailer.some_mail.deliver
```

or enqueue for bulk sending
```ruby
Mailer.some_mail.queue
Mailer.some_mail.queue
Mailer.some_mail.queue
Papio.queue.deliver
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wirelab/papio.
