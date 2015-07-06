module Papio
  class Mailer
    class << self
      def respond_to?(method)
        public_instance_methods(false).include?(method) || super
      end

      def method_missing(method, *args, &block)
        if respond_to?(method)
          new.public_send(method, *args, &block)
        else
          super
        end
      end

      def default options={}
        @default ||= {merge_language: 'mailchimp'}
        @default.merge!(options)
      end
    end

    # @param vars [Hash] the merge vars to be used. If you leave this empty, it will use the instance_variables like ActionMailer does.
    # @return [Mail] returns the mail to be sent.
    def mail(to:, vars:merge_vars, from:self.class.default[:from],
            subject:self.class.default[:subject], tags:self.class.default[:tags],
            template:self.class.default.fetch(:template),
            merge_language:self.class.default[:merge_language])
      Mail.new(to: to, vars:vars, from:from, subject:subject, template:template,merge_language:merge_language, tags:tags)
    end

    private

    def merge_vars
      instance_variables.reduce({}) do |hash, sym|
        hash[sym.to_s[1..-1].to_sym] = instance_variable_get(sym)
        hash
      end
    end
  end
end
