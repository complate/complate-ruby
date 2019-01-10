require 'fileutils'

require 'complate/compiler'
require 'complate/stream'

module Complate
  class TemplateHandler

    def self.call(template)
      id, compilate = register_source(template.identifier)
      "Complate::TemplateHandler.render(#{compilate.path.inspect}, #{id.inspect}, view_flow, assigns, controller)"
    end

    def self.render(compilate_path, id, view_flow, assigns, controller)
      renderer = Complate::renderer(compilate_path,
        no_reuse: Rails.configuration.complate.autorefresh,
        logger: Rails.logger)
      renderer.helpers = controller.helpers
      view_content = renderer.convert_safe_string(view_flow.content[:layout].html_safe)
      renderer.render(id, assigns.merge(content: view_content), fragment: !view_flow.content[:layout].present?).to_s
    end

    def self.register_source(src_file_name)
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

    def self.compile(id, src_file_name)
      FileUtils.mkdir_p(Rails.root.join('tmp/complate'))
      outfile = File.new(Rails.root.join('tmp/complate', "#{id}.js"), "w")
      Complate::Compiler.compile({id => src_file_name}, outfile, Rails.root.join('tmp/complate'))
      outfile
    end

  end
end
