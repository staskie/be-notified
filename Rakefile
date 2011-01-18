require 'rubygems'
require 'rake'
require 'echoe'

require File.expand_path('../lib/be_notified/version', __FILE__)

task :default => :test

require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

Echoe.new('benotified', BeNotified::VERSION) do |p|
  p.description    = "Library to monitor your programs and resources. It will notify you by email or just log the event if something goes wrong."
  p.url            = "http://github.com/staskie/be-notified"
  p.author         = "Dominik Staskiewicz"
  p.email          = "stadominik @nospam@ gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end