require "papio/version"
require "papio/config"
require "papio/sender"
require "papio/mail"
require "papio/mailer"

module Papio
  def self.configure
    @config ||= Config.new
    yield config if block_given?
    @config
  end

  def self.config
    @config || configure
  end
end
