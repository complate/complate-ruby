module Complate
  module Stream

    # This class implements a complate stream useable for
    # rack chunking and `to_s` conversion
    class Enumerator < ::Enumerator
      def initialize(&block)
        @after_start = block
        @buf = ''
      end

      def writeln(str)
        write("#{str}\n")
      end

      def write(str)
        @buf << str
      end

      def each(&block)
        @block = block
        @after_start.call(self)
      end

      def flush(*_)
        if @block && @buf != ''
          @block.call(@buf)
          @buf = ''
        end
      end

      def close
        self.flush
      end

      def to_s
        self.inject(&:+)
      end
    end

  end
end
