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
        self.class.post('/messages/send-template.json', body: ({
          key: Papio.config.api_key,
          template_name: group[0].template,
          template_content: [],
          message: {
            to: group.map{ |mail| mail.to },
            inline_css: true,
            preserve_recipients: false,
            merge_language: group[0].merge_language,
            merge_vars: group.map{ |mail| {rcpt: mail.to[:mail], vars: mail.merge_vars} }
          }
        }).to_json)
      end
    end

    def render
      @mails.each do |mail|
        fail 'Not yet implemented'
        # TODO: Render (using mandrill) and open in browser (using launchy)
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
      @mails.group_by{|mail| [mail.template,mail.merge_language]}.values
    end
  end
end
