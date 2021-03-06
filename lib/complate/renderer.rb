require 'therubyracer'

require 'complate/stream/enumerator'
require 'complate/stream/proxy'
require 'complate/utils/logger_wrapper'
require 'complate/utils/method_proxy'

module Complate
  class Renderer

    attr_reader :context

    def initialize(context_files, options = {})
      @context = V8::Context.new
      self.logger = options[:logger]

      Array(context_files).each do |file|
        @context.load(file)
      end
      if @context.scope['complate']
        @safe_string_converter = -> (s) { @context.scope.complate.safe(s) }
      else
        @safe_string_converter = nil
      end
    end

    def render(view, params, options = {})
      Stream::Enumerator.new do |stream|
        _render(stream, view, params, options)
      end
    end

    def render_to_stream(stream, view, params, options = {})
      _render(Stream::Proxy.new(stream), view, params, options)
    end

    def convert_safe_string(s)
      if s.present? && s.html_safe? && @safe_string_converter.present?
        @safe_string_converter.call(s)
      else
        s
      end
    end

    def logger=(logger)
      @context['console'] = Utils::LoggerWrapper.new(logger)
    end

    def helpers=(helpers)
      @context['rails'] = helpers && Utils::MethodProxy.new(helpers, self)
    end

    private

    def _render(stream, view, params, options)
      callback = -> () {
        stream.close
      }
      # The signature is:
      # (view, params, stream, { fragment }, callback)
      if @context.scope['complate']
        @context.scope.complate.render(view, params, stream, options, callback)
      else
        @context.scope.render(view, params, stream, options, callback)
      end
    end

  end

  def self.renderer(context_files, options = {})
    return Renderer.new(context_files, options) if options[:no_reuse]

    @renderer_instances||= {}

    if (options[:check_context_files])
      options = options.dup
      options[:context_file_shas] = Array(context_files).map { |context_file|
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
