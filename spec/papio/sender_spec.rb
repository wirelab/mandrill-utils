require 'spec_helper'

module Papio
  describe Sender do
    describe '.send' do
      it 'raises an error on status not 200' do
        stub_request(:post, 'https://mandrillapp.com/api/1.0/messages/send-template.json').
          to_return(body: {'message' => 'Wrong!'}.to_json, status: 500)

        expect{Sender.new([Mail.new(to:'a@b.c',template:'a')]).send}.to raise_error(Sender::Error)
      end
    end

    describe '.render' do
      it 'raises an error on status not 200' do
        stub_request(:post, 'https://mandrillapp.com/api/1.0/templates/render.json').
          to_return(body: {'message' => 'Wrong!'}.to_json, status: 500)

        expect{Sender.new([Mail.new(to:'a@b.c',template:'a')]).render}.to raise_error(Sender::Error)
      end
    end
  end
end
