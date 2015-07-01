module Papio
  class Mail
    attr_reader :to, :from
    attr_accessor :subject, :template, :merge_language, :vars
    # subaccount
    # reply-to

    # To, From must be a string (tim@wirelab.nl), or a hash ({email: 'tim@wirelab.nl', name: 'Tim'})
    def initialize(to:, template:, merge_language:'mailchimp', from:nil, vars:{}, subject:nil)
      self.to = to
      self.from = from
      self.template = template
      self.merge_language = merge_language
      self.vars = vars
      self.subject = subject
    end

    def merge_vars
      @vars.map do |k,v|
        {name: k, content: v}
      end
    end

    def to=(value)
      @to = email_to_hash(value)
    end

    def from=(value)
      @from = email_to_hash(value)
    end

    # Send the mail.
    def send
      Sender.new(self).send
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
