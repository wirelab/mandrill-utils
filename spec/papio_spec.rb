require 'spec_helper'

describe Papio do
  it 'has a version number' do
    expect(Papio::VERSION).not_to be nil
  end

  describe '::queue' do
    it 'is thread local' do
      queue1 = Thread.new{Papio.queue}.value
      queue2 = Thread.new{Papio.queue}.value
      expect(queue1).to_not eq queue2
    end
    it 'is a queue' do
      expect(Papio.queue.count).to eq 0
    end
  end

  describe '::config' do
    it 'is a config object' do
      expect(Papio.config.api_key).to be nil
    end
  end

  describe '::configure' do
    it 'yield config to the block' do
      Papio.configure { |config| config.api_key = 'test'}
      expect(Papio.config.api_key).to eq 'test'
    end
  end
end
