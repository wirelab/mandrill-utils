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

    def mail(to:, vars:{}, from:self.class.default[:from],
             subject:self.class.default[:subject],
             template:self.class.default.fetch(:template),
             merge_language:self.class.default[:merge_language])
      Mail.new(to: to, vars:vars, from:from, subject:subject, template:template,merge_language:merge_language)
    end
  end
end
