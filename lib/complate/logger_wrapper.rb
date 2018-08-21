module Complate
  class LoggerWrapper
    def initialize(logger)
      @logger = logger
    end

    def info(*msg)
      @logger.info(format_message(msg))
    end
    alias log info

    def warn(*msg)
      @logger.warn(format_message(msg))
    end

    def error(*msg)
      @logger.error(format_message(msg))
    end

    def debug(*msg)
      @logger.debug(format_message(msg))
    end

    private

    def format_message(msg)
      msg.join(" ")
    end
  end
end
