require 'fileutils'

require 'complate/compiler'
require 'complate/stream'

module Complate
  class TemplateHandler

    def self.call(template)
      id = Complate::Compiler.generate_id_for(template.identifier, ActionController::Base.view_paths)
      compilate = registerSource(id, template.identifier)
      "Complate::TemplateHandler.render(#{compilate.path.inspect}, #{id.inspect}, assigns, controller)"
    end

    def self.render(compilate_path, id, assigns, controller)
      renderer = Complate::renderer(compilate_path,
        no_reuse: Rails.configuration.complate.autorefresh,
        logger: Rails.logger)
      renderer.context['rails'] = controller.helpers
      renderer.render(id, assigns, fragment: true).to_s
    end

    def self.registerSource(id, src_file_name)
      if !Rails.configuration.complate.autocompile
        File.new(Rails.configuration.complate.bundle_path)
      elsif Rails.configuration.complate.autorefresh
        compile(id, src_file_name)
      else
        @compilates||= {}
        @compilates[id]||= compile(id, src_file_name)
      end
    end

    def self.compile(id, src_file_name)
      FileUtils.mkdir_p(Rails.root.join('tmp/complate'))
      outfile = Tempfile.new([id, '.js'], Rails.root.join('tmp/complate'))
      Complate::Compiler.compile({id => src_file_name}, outfile, Rails.root.join('tmp/complate'))
      outfile
    end

  end
end
