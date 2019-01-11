module Complate
  module Stream

    # This is a proxy for complate to work with
    # ActionDispatch::Response::Buffer from
    # ActionController::Live
    class Proxy
      def initialize(stream)
        @stream = stream
        @buf = ''
      end

      def writeln(str)
        write("#{str}\n")
      end

      def write(str)
        @buf << str
      end

      def flush(*_)
        if @buf != ''
          @stream.write(@buf)
          @buf = ''
        end
      end

      def close
        self.flush
        @stream.close
      end
    end

  end
end
