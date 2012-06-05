require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
end

task :submodules do
  sh "git submodule update --init"
end

task :test => :submodules
