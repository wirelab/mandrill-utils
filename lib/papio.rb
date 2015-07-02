require "papio/version"
require "papio/config"
require "papio/sender"
require "papio/mail"
require "papio/mailer"
require "papio/email_sanitizer"
require "papio/queue"

module Papio
  # Configure papio.
  # @yield [config] the config object to config.
  # @return [Config] the config
  def self.configure
    yield config if block_given?
    config
  end

  # Config object
  def self.config
    @config ||= Config.new
  end

  # The mail queue. This is thread local to prevent threading issues.
  def self.queue
    Thread.current['papio_queue'] ||= Papio::Queue.new
  end
end
