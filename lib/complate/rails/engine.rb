module Complate
  module Rails

    class Engine < ::Rails::Engine
    end

    class HelpersWrapper

      def initialize(controller)
        @controller = controller
      end

      def [](name)
        -> (*args) {
          @controller.helpers.send(name.to_s, *args[1..-1])
        }
      end

    end

    module ActionControllerExtensions

      extend ActiveSupport::Concern

      def complate(*args)
        renderer = Complate::Renderer.new('dist/bundle.js')
        renderer.context['rails'] = self.helpers
        self.response_body = renderer.render(*args)
      end
    end
  end
end
