module Complate
  module Rails

    class Engine < ::Rails::Engine
    end

    module ActionControllerExtensions

      extend ActiveSupport::Concern

      def complate(*args)
        renderer = Complate::Renderer.new('dist/bundle.js')
        self.response_body = renderer.render(*args)
      end
    end
  end
end
