require 'securerandom'
require 'launchy'
require 'httparty'

module Papio
  class Sender
    include HTTParty
    base_uri 'https://mandrillapp.com/api/1.0/'
    debug_output $stderr
    format :json

    def initialize(mails=[])
      @mails = Array(mails)
    end

    def send
      groups.map do |group|
        # https://mandrillapp.com/api/docs/messages.JSON.html#method=send-template
        body = {
          key: Papio.config.api_key,
          template_name: group[0].template,
          template_content: [],
          message: {
            to: group.map(&:to),
            headers: {
            },
            inline_css: true,
            preserve_recipients: false,
            merge_language: group[0].merge_language,
            merge_vars: group.map(&:rcpt_merge_vars)
          }
        }

        body[:message][:headers]['Reply-To'] = EmailSanitizer.sanitize group[0].reply_to if group[0].reply_to

        self.class.post('/messages/send-template.json', body: body.to_json)
        # TODO: Do something with the return value
      end
    end

    def render
      @mails.each do |mail|
        # https://mandrillapp.com/api/docs/templates.JSON.html#method=render
        body = {
          key: Papio.config.api_key,
          template_name: mail.template,
          template_content: [],
          merge_vars: mail.merge_vars
        }

        result = self.class.post('/templates/render.json', body: body.to_json)
        # Test if result is not an error
        filename = File.join(Papio.config.temp_directory, "#{SecureRandom.hex(16)}.html")
        File.write filename, result['html']
        Launchy.open filename
      end
    end

    def deliver
      if Papio.config.development
        render
      else
        send
      end
    end

    private

    def groups
      @mails.group_by(&:group).values
    end
  end
end
