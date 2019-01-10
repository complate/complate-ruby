module Complate

  module Compiler

    def self.generate_id_for(file_name, view_paths)
      file_name.
        gsub(/^(#{view_paths.map {|p| Regexp.escape(p.to_s) + '\/?'}.join('|')})/, '').
        gsub(/\.(jsx|tsx|js)$/, '').
        split('/').
        map { |s| s.camelize(:lower) }.
        join('_').
        gsub(/[^a-zA-Z0-9]/, '_')
    end

    def self.compile(inputs, to_file, view_file_dir = Dir.tmpdir)
      view_file = Tempfile.new(['complateViewFile', '.js'], view_file_dir)
      view_file.write(generate_view_file_contents(inputs))
      view_file.rewind
      FaucetCompiler.new.compile(view_file, to_file)
    ensure
      view_file.unlink if view_file
    end

    def self.generate_view_file_contents(inputs)
<<-eof
import Renderer, {safe} from 'complate-stream';
#{inputs.map { |id, src_file_name| "import #{id} from '#{src_file_name}';" }.join("\n")}

let renderer = new Renderer('<!DOCTYPE html>');
#{inputs.keys.map { |id| "renderer.registerView(#{id}, '#{id}');" }.join("\n")}
let render = renderer.renderView.bind(renderer);

export { render, safe };
eof
    end

    class FaucetCompiler

      def compile(src_file, to_file)
        tmp_config_file = Tempfile.new(['faucet-config', '.js'])
        tmp_config_file.write(<<-eof)
          module.exports = {
            js: [{
              source: "#{src_file.path}",
              target: "#{to_file.path}",
              exports: "complate",
              esnext: true,
              jsx: { pragma: "createElement" }
            }]
          };
        eof
        tmp_config_file.close
        `cd #{Rails.root}; node_modules/.bin/faucet -c #{tmp_config_file.path}`
        to_file.rewind
        to_file
      ensure
        tmp_config_file.unlink if tmp_config_file
      end

    end

  end
end
