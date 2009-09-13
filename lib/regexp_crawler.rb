require 'net/http'
require 'uri'
require 'iconv'
require 'logger'
require 'regexp_crawler/http'
require 'regexp_crawler/crawler'

module RegexpCrawler

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def regexp_crawler(options)
      @crawlers ||= []
      @crawlers << Crawler.new(options)
    end

    def start_crawl
      @crawlers.each do |crawler|
        crawler.start
      end
    end
  end

end
