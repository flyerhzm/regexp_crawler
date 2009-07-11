require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'

desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
   t.rcov = true
   t.rcov_opts = ['--exclude', 'spec,config,Library,usr/lib/ruby']
   t.rcov_dir = File.join(File.dirname(__FILE__), "tmp")
end
