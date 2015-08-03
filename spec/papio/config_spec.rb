require 'spec_helper'

module Papio
  describe Config do
    describe '.api_key' do
      it 'defaults to nil' do
        expect(Config.new.api_key).to be_nil
      end
    end

    describe '.development' do
      it 'defaults to false' do
        expect(Config.new.development).to be_falsey
      end
    end

    describe '.temp_directory' do
      it 'defaults to Dir.tmpdir' do
        expect(Config.new.temp_directory).to eq Dir.tmpdir
      end
    end

    describe '.default_url_options' do
      it 'defaults to {}' do
        expect(Config.new.default_url_options).to eq({})
      end
    end
  end
end
