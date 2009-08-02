module RegexpCrawler
  class Crawler
    attr_accessor :start_page, :continue_regexp, :named_captures, :model

    def initialize(options = {})
      @start_page = options[:start_page]
      @continue_regexp = options[:continue_regexp]
      @capture_regexp = options[:capture_regexp]
      @named_captures = options[:named_captures]
      @model = options[:model]
    end

    def capture_regexp=(regexp)
      @capture_regexp = Regexp.new(regexp.source, regexp.options | Regexp::MULTILINE)
    end

    def start
      results = []
      @pages = [@start_page]
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
          url = page.start_with?(uri.scheme) ? page : "#{uri.scheme}://#{uri.host}/#{page}"
          @pages << url
        end if continue_regexp
        md = @capture_regexp.match(response.body)
        if md
          model_result = model.new
          captures = md.captures if md
          captures.each_index do |i|
            model_result.send("#{named_captures[i]}=", captures[i])
          end
          {:model => model_result, :page => "#{uri.scheme}://#{uri.host}#{uri.path}"}
        end
      elsif response.is_a? Net::HTTPRedirection
        parse_page(URI.parse(response['location']))
      else
      end
    end
  end
end
