require 'rake/testtask'

task :default => :test

Rake::TestTask.new

task :submodules do
  sh "git submodule update --init"
end

task :test => :submodules
