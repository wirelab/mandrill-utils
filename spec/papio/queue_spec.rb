require 'spec_helper'

module Papio
  describe Queue do
    describe '.count' do
      it 'returns the amount of unsent emails in the queue' do
        subject << 1
        subject << 2
        expect(subject.count).to eq 2
      end
    end

    describe '.add' do
      it 'adds messages to the queue' do
        expect(subject.count).to eq 0
        subject.add(1)
        expect(subject.count).to eq 1
      end
    end

    describe '.clear' do
      it 'removes all messages from the queue' do
        subject.add 1
        subject.add 2
        subject.add 3
        expect(subject.count).to eq 3
        subject.clear
        expect(subject.count).to eq 0
      end
    end

    describe '.send' do
      let(:value) { double }
      let(:sender) { double('sender', send: value).as_null_object }

      it 'returns the value from sender' do
        expect(Queue.new(sender: sender).send).to eq value
      end

      it 'delegates to sender' do
        Queue.new(sender: sender).send
        expect(sender).to have_received :send
      end

      it 'clears the queue' do
        queue = Queue.new(sender: sender)
        queue.add 1
        queue.send
        expect(queue.count).to eq 0
      end
    end

    describe '.render' do
      let(:value) { double }
      let(:sender) { double('sender', render: value).as_null_object }

      it 'returns the value from sender' do
        expect(Queue.new(sender: sender).render).to eq value
      end

      it 'delegates to sender' do
        Queue.new(sender: sender).render
        expect(sender).to have_received :render
      end

      it 'clears the queue' do
        queue = Queue.new(sender: sender)
        queue.add 1
        queue.render
        expect(queue.count).to eq 0
      end
    end

    describe '.deliver' do
      let(:value) { double }
      let(:sender) { double('sender', deliver: value).as_null_object }

      it 'returns the value from sender' do
        expect(Queue.new(sender: sender).deliver).to eq value
      end

      it 'delegates to sender' do
        Queue.new(sender: sender).deliver
        expect(sender).to have_received :deliver
      end

      it 'clears the queue' do
        queue = Queue.new(sender: sender)
        queue.add 1
        queue.deliver
        expect(queue.count).to eq 0
      end
    end
  end
end
