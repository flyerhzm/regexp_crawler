require 'net/http'
require 'uri'

class RegexpCrawler
  attr_accessor :start_page, :continue_regexp, :named_captures, :model

  def capture_regexp=(regexp)
    @capture_regexp = Regexp.new(regexp.source, regexp.options | Regexp::MULTILINE)
  end

  def start
    pages = [start_page]
    results = []
    while !pages.empty?
      uri = URI.parse(pages.shift)
      res = Net::HTTP.get_response(uri)
      if res.is_a? Net::HTTPSuccess
        res.body.scan(continue_regexp).each do |page|
          url = page.start_with?('http://') ? page : "http://#{uri.host}/#{page}"
          pages << url
        end if continue_regexp
        md = @capture_regexp.match(res.body)
        if md
          result = model.new
          captures = md.captures if md
          captures.each_index do |i|
            result.send("#{named_captures[i]}=", captures[i])
          end
          puts result.inspect
          results << result
        end
      elsif res.is_a? Net::HTTPRedirection
      else
      end
    end
    results
  end
end
