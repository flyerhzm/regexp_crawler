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
      @captured_pages = []
      @pages = [URI.parse(@start_page)]
      while !@pages.empty?
        uri = @pages.shift
        @captured_pages << uri
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
          page = page.first if page.is_a? Array
          continue_uri = page.start_with?(uri.scheme) ? URI.parse(page) : URI.join(uri.scheme + '://' + uri.host, page)
          @pages << continue_uri unless @captured_pages.include?(continue_uri) or @pages.include?(continue_uri)
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
