require 'spec_helper'

module Papio
  describe Mail do
    %w(send render deliver).each do |method_name|
      describe ".#{method_name}" do
        it 'delegates self to Sender' do
          sender = double(method_name => nil).as_null_object
          Mail.new(to: 'test@example.com', template: 'test-template', sender: sender).public_send(method_name)
          expect(sender).to have_received method_name
        end
      end
    end

    describe '.queue' do
      it 'adds itself to the queue' do
        queue = Queue.new
        Mail.new(to: 'test@example.com', template: 'test-template', queue: queue).queue
        expect(queue.count).to eq 1
      end
    end

    describe '.to' do
      it 'transforms strings to a hash' do
        expect(Mail.new(to: 'test@example.com', template: 'test-template').to).to eq({email: 'test@example.com'})
      end

      it 'keeps hashes intact' do
        expect(Mail.new(to: {email:'test@example.com'}, template: 'test-template').to).to eq({email: 'test@example.com'})
      end
    end

    describe '.group' do
      it 'returns a array of things to group by' do
        group = Mail.new(to: 'test@example.com', template: 'test-template', from: 'from', reply_to: 'reply_to').group
        expect(group).to eq ["test-template", "mailchimp", {:email=>'reply_to'}, {:email=>'from'}, []]
      end
    end

    describe '.merge_vars' do
      it 'returns a hash of vars in mandrill format' do
        mail = Mail.new(to: 'to', template: 'template', vars: {a:1,b:2})
        expect(mail.merge_vars).to eq([{name: :a, content: 1}, {name: :b, content: 2}])
      end
    end

    describe '.rcpt_merge_vars' do
      it 'returns a hash of rcpt merge vars' do
        mail = Mail.new(to: 'to', template: 'template', vars: {a:1,b:2})
        expect(mail.rcpt_merge_vars).to eq({rcpt: 'to', vars: [{name: :a, content: 1}, {name: :b, content: 2}]})
      end
    end
  end
end
