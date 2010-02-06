require 'rubygems'
require 'regexp_crawler'

class Project
  attr_accessor :title, :description, :body, :url

  def initialize(options)
    options.each do |k, v|
      self.instance_variable_set("@#{k}", v)
    end
  end
end

projects = []
crawler = RegexpCrawler::Crawler.new(
  :start_page => "http://github.com/flyerhzm",
  :continue_regexp => %r{<h3>[\s|\n]*?<a href="(/flyerhzm/.*?)">}m,
  :capture_regexp => %r{<a href="http://github.com/flyerhzm/[^"]*?">(.*?)</a>.*?<div id="repository_description".*?>[\s|\n]*?<p>(.*?)[\s|\n]*?<span id="read_more".*(<div class="wikistyle">.*?</div>)</div>}m,
  :named_captures => ['title', 'description', 'body'],
  :logger => true,
  :save_method => Proc.new do |result, page|
    projects << Project.new(result.merge(:url => page))
  end,
  :need_parse => Proc.new do |page, response_body|
    !response_body.index(/<span class="fork-flag">/)
  end)
crawler.start

projects.each do |project|
  puts project.url
  puts project.title
  puts project.description
end
