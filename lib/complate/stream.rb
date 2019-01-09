module Complate
  class Stream < Enumerator
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
      flush
    end

    def flush(*_)
      if @block && @buf != ''
        @block.call(@buf)
        @buf = ''
      end
    end

    def to_s
      map(&:to_s).join()
    end
  end
end
