require 'complate/renderer'

module Complate
  module Rails
    class Engine < ::Rails::Engine
    end

    module ActionControllerExtensions
      extend ActiveSupport::Concern

      def complate(*args)
        # TODO Make configurable
        renderer = Complate::Renderer.new('dist/bundle.js')
        renderer.context['rails'] = self.helpers
        renderer.logger = ::Rails.logger
        self.response_body = renderer.render(*args)
      end
    end
  end
end
