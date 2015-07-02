module Papio
  class Queue
    # @param sender [Sender] the sender to use.
    def initialize sender:Sender
      @sender = sender
      @queue = []
    end

    # The number of items in the queue.
    def count
      @queue.count
    end

    # Add a item to the queue
    def add mail
      @queue << mail
    end

    alias << add

    # Clear the queue
    def clear
      @queue = []
    end

    # Send all items in the queue then clear it.
    def send
      result = @sender.new(@queue).send
      clear
      result
    end

    # Renders all items in the queue then clears it.
    def render
      result = @sender.new(@queue).render
      clear
      result
    end

    # Delivers all items in the queue then clears it.
    def deliver
      result = @sender.new(@queue).deliver
      clear
      result
    end
  end
end
