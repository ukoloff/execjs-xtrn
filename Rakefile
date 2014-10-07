require "bundler/gem_tasks"

desc 'Install NPM modules'
task :npm do
  system "npm", "install", :chdir=>"lib/execjs/node"
end

desc 'Run tests'
task :test do
  require "minitest/autorun"

  require 'execjs/xtrn'

  Dir.glob('./test/*.rb'){|f| require f}
end

task :default=>:test
