require 'mini_racer'
require 'complate/stream'
require 'complate/logger_wrapper'

module Complate
  class Renderer
    attr_reader :context

    def initialize(*context_files)
      @context = MiniRacer::Context.new
      context_files.each do |file|
        @context.load(file)
      end
    end

    def render(view, params = {})
      Stream.new do |stream|
        # The signature is:
        # (view, params, stream, { fragment }, callback)
        @context.call("render", view, params, stream, {})
      end
    end

    def logger=(logger)
      # @context.attach('console', LoggerWrapper.new(logger))
    end
  end
end
