require 'redis'

class Redis
  class Retry
    # The number of times a command will be retried if a connection cannot be
    # made to Redis.  If zero, retry forever.
    attr_accessor :tries

    # The number of seconds to wait before retrying a command.
    attr_accessor :wait

    def initialize(options = {})
      @tries = options[:tries] || 3
      @wait  = options[:wait]  || 2
      @redis = options[:redis]
    end

    # Ruby defines a now deprecated type method so we need to override it here
    # since it will never hit method_missing.
    def type(key)
      method_missing(:type, key)
    end

    def method_missing(command, *args, &block)
      try = 1
      exception = nil
      while try <= @tries
        begin
          # Dispatch the command to Redis
          return @redis.send(command, *args, &block)
        rescue Errno::ECONNREFUSED, Errno::ECONNRESET => e
          try += 1
          exception = e
          sleep @wait
        end
      end

      # Ran out of retries
      raise exception
    end

    def respond_to?(method)
      return true if super(method)

      @redis.respond_to?(method)
    end
  end
end
