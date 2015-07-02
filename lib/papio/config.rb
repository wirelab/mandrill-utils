require 'tmpdir'

module Papio
  class Config
    attr_accessor :api_key
    attr_accessor :development
    attr_accessor :temp_directory

    def initialize
      @development = false
      @temp_directory = Dir.tmpdir
    end
  end
end
