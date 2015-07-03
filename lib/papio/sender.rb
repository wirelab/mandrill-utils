require 'securerandom'
require 'launchy'
require 'httparty'

module Papio
  class Sender
    class Error < StandardError
    end

    include HTTParty
    base_uri 'https://mandrillapp.com/api/1.0/'
    #debug_output $stderr
    format :json

    # @param mails [Array] the mails to deliver.
    def initialize(mails=[])
      @mails = Array(mails)
    end

    # Send to all mails specified in the constructor.
    # @return [Hash] with the status as the key and the messages with that status as a value array. possible statusses are: sent, invalid, rejected, queued.
    def send
      responses = groups.map do |group|
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

        response = self.class.post('/messages/send-template.json', body: body.to_json)
        raise Error, response.parsed_response['message'] if response.code != 200
        response.parsed_response
        # TODO: Do something with the return value
      end.flatten
      responses.group_by { |r| r['status'].to_sym }
    end

    # Render all mails to files and open in the browser.
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
        raise Error, result.parsed_response['message'] if response.code != 200
        filename = File.join(Papio.config.temp_directory, "#{SecureRandom.hex(16)}.html")
        File.write filename, result['html']
        Launchy.open filename
      end
    end

    # Deliver all mails. This either sends or renders all emails depending on development state.
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
