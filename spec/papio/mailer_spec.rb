require 'spec_helper'

module Papio
  describe Mailer do
    class ExampleMailer < Mailer
      default subject: 'The Subject'
      def an_email
        @title = 'Hello, World!'
        mail to: 'test@example.com', template: 'test-template'
      end
    end
    it 'generates an email' do
      mail = ExampleMailer.an_email
      expect(mail.to[:email]).to eq 'test@example.com'
      expect(mail.template).to eq 'test-template'
      expect(mail.vars).to eq({title: 'Hello, World!'})
      expect(mail.subject).to eq "The Subject"
    end

    describe 'path helpers' do
      Papio.configure do |config|
        config.default_url_options = { host: 'test.dev' }
      end

      class DummyMailer < Mailer
        default subject: 'The Subject'
        def an_email
          @title = dummies_url
          mail to: 'test@example.com', template: 'test-template'
        end
      end

      it 'has path helpers' do
        expect(DummyMailer.an_email.vars[:title]).to eq 'http://test.dev/dummies'
      end

    end
  end
end
