require 'complate/renderer'

module Complate
  class Railtie < Rails::Railtie
    config.complate = ActiveSupport::OrderedOptions.new

    ActiveSupport.on_load(:action_controller) do
      define_method(:complate) do |*args|
        renderer = Complate.renderer(Rails.configuration.complate.bundle_path, check_context_files: Rails.env.development?)
        renderer.context['rails'] = self.helpers
        renderer.logger = ::Rails.logger
        self.response_body = renderer.render(*args)
      end
    end

    initializer "complate.configure_bundle_path" do |app|
      app.config.complate.bundle_path ||= app.root.join("dist", "bundle.js")
    end
  end
end
