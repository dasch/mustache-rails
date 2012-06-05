require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.warning = true
end

task :submodules do
  sh "git submodule update --init"
end

task :test => :submodules
