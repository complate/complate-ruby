require 'therubyracer'

require 'complate/version'

module Complate
  class Renderer
    attr_reader :context

    def initialize(*context_files)
      @context = V8::Context.new
      @context['console'] = Console.new
      context_files.each do |file|
        @context.load(file)
      end
    end

    def render(view, params = {})
      Stream.new do |stream|
        @context.scope.render(view, params, stream, {})
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
