require 'therubyracer'

require 'complate/version'

module Complate
  class Renderer
    def initialize(*context_files)
      @cxt = V8::Context.new
      @cxt['console'] = Console.new
      context_files.each do |file|
        @cxt.load(file)
      end
    end

    def render(*args)
      Stream.new do |stream|
        @cxt.scope.render(stream, *args)
      end
    end
  end

  class Console
    def log(*msg)
      puts msg
    end
  end

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
  end
end
