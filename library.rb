# What is this shit with unusedArgs? See here:
# https://groups.google.com/forum/#!topic/javascript-and-friends/ezJ2RX3pwBU
require 'v8'

class JSX
  class Console
    def log(*msg)
      puts msg
    end
  end

  class Stream
    def writeln(str)
      puts str
    end

    def write(str)
      print str
    end

    def flush(*unusedArgs)
    end
  end

  class Java
    def from(a)
      a
    end
  end

  def initialize(path)
    @cxt = V8::Context.new

    # Standard Library
    @cxt['console'] = Console.new
    @cxt['_stream'] = Stream.new
    @cxt['Java'] = Java.new

    # Load the views
    @cxt.load(path)
  end

  def render(path, *args)
    injectedArguments = '_stream'

    args.each_with_index do |arg, position|
      @cxt["_arg#{position}"] = arg
      injectedArguments = injectedArguments + ", _arg#{position}"
    end

    @cxt.eval("render('#{path}', #{injectedArguments})")
  end
end
