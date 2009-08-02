# -*- encoding: utf-8 -*-
require 'rubygems'

Gem::Specification.new do |s|
  s.name = %q{regexp_crawler}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Richard Huang"]
  s.date = %q{2009-08-01}
  s.description = %q{RegexpCrawler is a Ruby library for crawl data from website using regular expression.}
  s.email = %q{flyerhzm@gmail.com}
  s.extra_rdoc_files = ["README", "LICENSE"]
  s.files = ["README", "LICENSE", "Rakefile", "init.rb", "lib/regexp_crawler.rb", "lib/regexp_crawler/crawler.rb", "spec/spec_helper.rb", "spec/spec.opts", "spec/regexp_crawler_spec.rb", "spec/resources/simple.html", "spec/resources/complex.html", "spec/resources/nested1.html", "spec/resources/nested2.html"]
  s.has_rdoc = true
  s.homepage = %q{}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{regexp_crawler}
  s.rubygems_version = %q{0.1.0}
  s.summary = %q{RegexpCrawler is a Ruby library for crawl data from website using regular expression.}
end
