module Papio
  class Mail
    attr_reader :to, :from, :reply_to
    attr_accessor :subject, :template, :merge_language, :vars
    # subaccount

    # To, From, Reply_to must be a string (tim@wirelab.nl), or a hash ({email: 'tim@wirelab.nl', name: 'Tim'})
    def initialize(to:, template:, merge_language:'mailchimp', from:nil, vars:{}, subject:nil, reply_to:nil)
      self.to = to
      self.from = from
      self.template = template
      self.merge_language = merge_language
      self.vars = vars
      self.subject = subject
      self.reply_to = reply_to
    end

    def merge_vars
      @vars.map do |k,v|
        {name: k, content: v}
      end
    end

    def rcpt_merge_vars
      {
        rcpt: to[:email],
        vars: merge_vars
      }
    end

    def group
      [mail.template, mail.merge_language, mail.reply_to, mail.from]
    end

    def to=(value)
      @to = email_to_hash(value)
    end

    def from=(value)
      @from = email_to_hash(value)
    end

    def reply_to=(value)
      @reply_to = email_to_hash(value)
    end

    # Send the mail.
    def send
      Sender.new(self).send
    end

    # Queue the mail.
    def queue
      Papio.queue.add self
    end

    # Render this mail to html.
    # This will not send an email.
    def render
      Sender.new(self).render
    end

    # Render and open in a browser or send the email based on development state.
    def deliver
      Sender.new(self).deliver
    end

    private

    def email_to_hash(value)
      if value.is_a? Hash
        value
      else
        # TODO: Split on <> in case a name was given.
        {email: value}
      end
    end
  end
end
