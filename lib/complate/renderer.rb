require 'therubyracer'
require 'complate/stream'
require 'complate/logger_wrapper'
require 'complate/method_proxy'

module Complate
  class Renderer

    attr_reader :context

    def initialize(context_files, options = nil)
      @context = V8::Context.new
      self.logger = options[:logger]

      Array.wrap(context_files).each do |file|
        @context.load(file)
      end
      if @context.scope['complate']
        @safe_string_converter = -> (s) { @context.scope.complate.safe(s) }
      else
        @safe_string_converter = nil
      end
    end

    def render(view, params, options = {})
      Stream.new do |stream|
        # The signature is:
        # (view, params, stream, { fragment }, callback)
        if @context.scope['complate']
          @context.scope.complate.render(view, params, stream, options)
        else
          @context.scope.render(view, params, stream, options)
        end
      end
    end

    def convert_safe_string(s)
      if s.present? && s.html_safe? && @safe_string_converter.present?
        @safe_string_converter.call(s)
      else
        s
      end
    end

    def logger=(logger)
      @context['console'] = LoggerWrapper.new(logger)
    end

    def helpers=(helpers)
      @context['rails'] = helpers && MethodProxy.new(helpers, self)
    end

  end

  def self.renderer(context_files, options = {})
    return Renderer.new(context_files, options) if options[:no_reuse]

    @renderer_instances||= {}

    if (options[:check_context_files])
      options = options.dup
      options[:context_file_shas] = Array.wrap(context_files).map { |context_file|
        Digest::SHA256.file(context_file).hexdigest
      }
    end
    candidate = @renderer_instances[context_files]
    if candidate && candidate[:options] == options
      candidate[:renderer]
    else
      renderer = Renderer.new(context_files, options)
      @renderer_instances[context_files] = { renderer: renderer, options: options }
      renderer
    end
  end

end
