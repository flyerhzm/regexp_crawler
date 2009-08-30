require 'net/http'
require 'uri'
require 'regexp_crawler/http'

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
