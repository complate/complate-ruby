require 'fileutils'

require 'complate/compiler'
require 'complate/renderer'

module Complate

  # This is a Template Handler for JSX complate views.
  # It allows usage of Rails `render` methods including JSX as
  # Views, Layouts and Partials.
  class TemplateHandler
    def self.call(template)
      id, compilate = register_source(template.identifier)
      "Complate::TemplateHandler.render(#{compilate.path.inspect}, #{id.inspect}, view_flow, assigns, local_assigns, controller)"
    end

    def self.render(compilate_path, id, view_flow, assigns, local_assigns, controller)
      renderer = Complate::renderer(compilate_path,
        no_reuse: Rails.configuration.complate.autorefresh,
        logger: Rails.logger)
      renderer.helpers = controller.helpers
      view_content = renderer.convert_safe_string(view_flow.content[:layout])
      all_assigns = assigns.merge(local_assigns).merge(content: view_content)
      is_outer_layout = view_flow.content[:layout].present? # TODO: This might be a problem with multiple nested layouts in one view
      renderer.render(id, all_assigns, fragment: !is_outer_layout).to_s.html_safe
    end

    def self.register_source(src_file_name)
      src_file_name = src_file_name.to_s if src_file_name.is_a?(File) || src_file_name.is_a?(Pathname)

      id = Complate::Compiler.generate_id_for(src_file_name, ActionController::Base.view_paths)
      if !Rails.configuration.complate.autocompile
        [id, File.new(Rails.configuration.complate.bundle_path)]
      elsif Rails.configuration.complate.autorefresh
        [id, compile(id, src_file_name)]
      else
        @compilates||= {}
        @compilates[id]||= [id, compile(id, src_file_name)]
      end
    end

    protected

    def self.compile(id, src_file_name)
      FileUtils.mkdir_p(Rails.root.join('tmp/complate'))
      outfile = File.new(Rails.root.join('tmp/complate', "#{id}.js"), "w")
      Complate::Compiler.compile({id => src_file_name}, outfile, Rails.root.join('tmp/complate'))
      outfile
    end
  end

end
