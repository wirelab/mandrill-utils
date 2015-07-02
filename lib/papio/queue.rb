module Papio
  class Queue
    def initialize sender:Sender
      @sender = sender
      @queue = []
    end

    def count
      @queue.count
    end

    def add mail
      @queue << mail
    end

    def << mail
      add mail
    end

    def clear
      @queue = []
    end

    def send
      result = @sender.new(@queue).send
      clear
      result
    end

    def render
      result = @sender.new(@queue).render
      clear
      result
    end

    def deliver
      result = @sender.new(@queue).deliver
      clear
      result
    end
  end
end
