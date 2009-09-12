require 'rubygems'
require 'regexp_crawler'

crawler = RegexpCrawler::Crawler.new(
  :start_page => "http://github.com/flyerhzm",
  :continue_regexp => %r{<div class="title"><b><a href="(/flyerhzm/.*?/tree)">}m,
  :capture_regexp => %r{<a href="http://github.com/flyerhzm/.*?/tree">(.*?)</a>.*<span id="repository_description".*?>(.*?)</span>.*(<div class="(?:wikistyle|plain)">.*?</div>)</div>}m,
  :named_captures => ['title', 'description', 'body'],
  :save_method => Proc.new do |result, page|
    puts '============================='
    puts page
    puts result[:title]
    puts result[:description]
    puts result[:body][0..100] + "..."
  end,
  :need_parse => Proc.new do |page, response_body|
    !response_body.index "Fork of"
  end)
crawler.start
