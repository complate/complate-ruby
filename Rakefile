require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :prepare_node_environment do
  Dir.chdir 'test/dummy_app' do
    system('npm install') || raise("npm install failed")
    system('node_modules/.bin/faucet -c ../js/faucet.config.js') || raise("faucet compile failed!")
  end
end

task :default => :test
