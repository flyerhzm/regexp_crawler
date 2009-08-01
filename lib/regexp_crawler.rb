require 'net/http'
require 'uri'

class RegexpCrawler
  attr_accessor :continue_regexp, :named_captures, :model

  def start_page=(page)
    @start_page = page
    @pages = [page]
  end

  def capture_regexp=(regexp)
    @capture_regexp = Regexp.new(regexp.source, regexp.options | Regexp::MULTILINE)
  end

  def start
    results = []
    while !@pages.empty?
      uri = URI.parse(@pages.shift)
      result = parse_page(uri)
      results << result if result
    end
    results
  end

  def parse_page(uri)
    response = Net::HTTP.get_response(uri)
    parse_response(response, uri)
  end

  def parse_response(response, uri)
    if response.is_a? Net::HTTPSuccess
      response.body.scan(continue_regexp).each do |page|
        url = page.start_with?('http://') ? page : "http://#{uri.host}/#{page}"
        @pages << url
      end if continue_regexp
      md = @capture_regexp.match(response.body)
      if md
        result = model.new
        captures = md.captures if md
        captures.each_index do |i|
          result.send("#{named_captures[i]}=", captures[i])
        end
        result
      end
    elsif response.is_a? Net::HTTPRedirection
      parse_page(URI.parse(response['location']))
    else
    end
  end
end
