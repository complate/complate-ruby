require 'therubyracer'
require 'complate/stream'
require 'complate/logger_wrapper'

module Complate
  class Renderer
    attr_reader :context

    def initialize(context_files)
      @context = V8::Context.new
      Array.wrap(context_files).each do |file|
        @context.load(file)
      end
    end

    def render(view, params = {})
      Stream.new do |stream|
        # The signature is:
        # (view, params, stream, { fragment }, callback)
        @context.scope.render(view, params, stream, {})
      end
    end

    def logger=(logger)
      @context['console'] = LoggerWrapper.new(logger)
    end

  end

  def self.renderer(context_files, options = {})
    @renderer_instances||= {}

    if (options[:check_context_files])
      options = options.dup
      options[:context_file_shas] = Array.wrap(context_files).map {
        Digest::SHA256.file(context_file).hexdigest
      }
    end
    candidate = @renderer_instances[context_files]
    if candidate && candidate[:options] == options
      candidate[:renderer]
    else
      renderer = Renderer.new(context_files)
      @renderer_instances[context_files] = { renderer: renderer, options: options }
      renderer
    end
  end

end
