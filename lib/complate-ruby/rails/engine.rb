module ComplateRuby
  module Rails

    class Engine < ::Rails::Engine
    end

    module ActionControllerExtensions

      extend ActiveSupport::Concern

      def complate(*args)
        headers['X-Accel-Buffering'] = 'no' # Stop NGINX from buffering
        headers["Cache-Control"] = "no-cache" # Stop downstream caching
        headers.delete("Content-Length") # See one line above

        renderer = ComplateRuby::Renderer.new('dist/bundle.js')
        self.response_body = renderer.render(*args)
      end

    end

  end
end
