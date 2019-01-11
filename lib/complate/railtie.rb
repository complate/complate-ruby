require 'complate/renderer'
require 'complate/template_handler'

module Complate
  class Railtie < Rails::Railtie
    config.complate = ActiveSupport::OrderedOptions.new
    config.complate.autocompile = !Rails.env.production?
    config.complate.autorefresh = Rails.env.development?

    rake_tasks do
      load File.expand_path('../../tasks/railtie.tasks', __FILE__)
    end

    initializer 'complate.handler.setup', :before => :add_view_paths do |app|
      ActiveSupport.on_load(:action_view) do
        ActionView::Template.register_template_handler(:jsx, ::Complate::TemplateHandler)
      end
    end

    ActiveSupport.on_load(:action_controller) do
      define_method(:complate) do |*args|
        options = args.extract_options!
        bundle_path = options.delete(:bundle_path) || Rails.configuration.complate.bundle_path
        autorefresh = options.delete(:bundle_path) || Rails.configuration.complate.autorefresh
        args = args.push(options)

        renderer = Complate.renderer(bundle_path, check_context_files: autorefresh)
        renderer.helpers = self.helpers
        renderer.logger = ::Rails.logger

        if (self.is_a?(ActionController::Live))
          renderer.render_to_stream(response.stream, *args)
        else
          self.response_body = renderer.render(*args).to_s
        end
      end

      define_method(:complate_stream) do |action_name = nil|
        raise "Controller #{self.class.name} must `include ActionController::Live` to allow streaming" unless self.is_a?(ActionController::Live)

        action_name||= self.action_name
        view_file = self.lookup_context.find(action_name, _prefixes, false)
        id, compilate = Complate::TemplateHandler.register_source(view_file.identifier)
        complate(id, self.view_assigns.merge(bundle_path: compilate.path))
      end
    end

    initializer "complate.configure_bundle_path" do |app|
      app.config.complate.bundle_path ||= app.root.join("dist", "bundle.js")
    end
  end
end
