module Papio
  class Mail
    attr_reader :to, :from, :reply_to
    attr_accessor :subject, :template, :merge_language, :vars
    # subaccount

    # To, From, Reply_to must be a string (tim@wirelab.nl), or a hash ({email: 'tim@wirelab.nl', name: 'Tim'})
    # @param sender [Sender] the sender to use
    # @param queue [Queue] the queue to use
    # @param vars [Hash] the merge vars for this email.
    def initialize(to:, template:, merge_language:'mailchimp',
                   from:nil, vars:{}, subject:nil, reply_to:nil,
                   sender:Sender, queue:Papio.queue)
      @queue = queue
      @sender = sender
      self.to = to
      self.from = from
      self.template = template
      self.merge_language = merge_language
      self.vars = vars
      self.subject = subject
      self.reply_to = reply_to
    end

    # @return [Array] the merge vars in mandrill format.
    def merge_vars
      @vars.map do |k,v|
        {name: k, content: v}
      end
    end

    # @return [Hash] the merge vars for the recipient in mandrill format.
    def rcpt_merge_vars
      {
        rcpt: to[:email],
        vars: merge_vars
      }
    end

    # @return [Array] the attributes to group by.
    def group
      [template, merge_language, reply_to, from]
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
      @sender.new(self).send
    end

    # Queue the mail.
    def queue
      @queue.add self
    end

    # Render this mail to html.
    # This will not send an email.
    def render
      @sender.new(self).render
    end

    # Render and open in a browser or send the email based on development state.
    def deliver
      @sender.new(self).deliver
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
