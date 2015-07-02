require 'tmpdir'

module Papio
  class Config
    # The mandrill API key
    attr_accessor :api_key
    # Whether to send or render emails.
    # If set to true this will emulate letter_opener behaviour.
    attr_accessor :development
    # The directory to store temporary files in for development mode.
    attr_accessor :temp_directory

    def initialize
      @development = false
      @temp_directory = Dir.tmpdir
    end
  end
end
