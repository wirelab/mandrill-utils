module Papio
  class Queue
    def initialize
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
      result = Sender.new(@queue).send
      clear
      result
    end

    def render
      result = Sender.new(@queue).render
      clear
      result
    end

    def deliver
      result = Sender.new(@queue).deliver
      clear
      result
    end
  end
end
