require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'
require 'jeweler'

desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec,config,Library,usr/lib/ruby']
  t.rcov_dir = File.join(File.dirname(__FILE__), "tmp")
end

Jeweler::Tasks.new do |gemspec|
  gemspec.name = "regexp_crawler"
  gemspec.summary = "RegexpCrawler is a Ruby library for crawl data from website using regular expression."
  gemspec.description = "RegexpCrawler is a Ruby library for crawl data from website using regular expression."
  gemspec.email = "flyerhzm@gmail.com"
  gemspec.homepage = "http://github.com/flyerhzm/regexp_crawler"
  gemspec.authors = ["Richard Huang"]
  gemspec.files.exclude '.gitignore'
end
