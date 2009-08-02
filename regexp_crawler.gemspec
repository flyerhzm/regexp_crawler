# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{regexp_crawler}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Richard Huang"]
  s.date = %q{2009-08-02}
  s.description = %q{RegexpCrawler is a Ruby library for crawl data from website using regular expression.}
  s.email = %q{flyerhzm@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README",
     "Rakefile",
     "TODO",
     "VERSION",
     "init.rb",
     "lib/regexp_crawler.rb",
     "lib/regexp_crawler/crawler.rb",
     "regexp_crawler.gemspec",
     "spec/regexp_crawler_spec.rb",
     "spec/resources/complex.html",
     "spec/resources/nested1.html",
     "spec/resources/nested2.html",
     "spec/resources/simple.html",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{RegexpCrawler is a Ruby library for crawl data from website using regular expression.}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/regexp_crawler_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
