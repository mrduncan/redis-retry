require 'rake/testtask'

task :default => :test

desc "Runs unit tests"
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test_*.rb']
end

desc "Build a gem"
task :gem => [:gemspec, :build]

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "redis-retry"
    gemspec.summary = "Auto-retries Redis commands."
    gemspec.email = "matt@mattduncan.org"
    gemspec.homepage = "http://github.com/mrduncan/redis-retry"
    gemspec.authors = ["Matt Duncan"]
    gemspec.version = '0.1.0'
    gemspec.add_dependency 'redis'
    gemspec.description = <<description
Adds a Redis::Retry class which can be used to proxy calls to Redis while
automatically retrying when a connection cannot be made.  This is useful
to ensure that your applications don't fail if Redis is temporarily
unavailable.
description
  end
rescue LoadError
  warn "Jeweler not available. Install it with:"
  warn "gem install jeweler"
end
