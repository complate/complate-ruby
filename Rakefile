require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :build_js_testdata do
  Dir.chdir 'test/js' do
    exec 'npm run compile'
  end
end

task :default => :test
