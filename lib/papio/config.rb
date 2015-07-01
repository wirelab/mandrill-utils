module Papio
  class Config
    attr_accessor :api_key
    attr_accessor :development

    def initialize
      @development = false
    end
  end
end
