require File.expand_path(File.dirname(__FILE__) + "/spec_helper.rb")

describe RegexpCrawler::Crawler do
  context '#simple html' do
    it 'should parse data according to regexp' do
      success_page('/resources/simple.html', 'http://simple.com/')

      crawl = RegexpCrawler::Crawler.new(:start_page => 'http://simple.com/', :capture_regexp => %r{<div class="title">(.*?)</div>.*<div class="date">(.*?)</div>.*<div class="body">(.*?)</div>}m, :named_captures => ['title', 'date', 'body'], :model => 'post', :logger => true)
      results = crawl.start
      results.size.should == 1
      results.first[:post][:title].should == 'test'
    end

    it 'should redirect' do
      redirect_page('http://redirect.com/', 'http://simple.com/')
      success_page('/resources/simple.html', 'http://simple.com/')
    end
  end

  context '#complex html' do
    before(:each) do
      success_page('/resources/complex.html', 'http://complex.com/')
      success_page('/resources/nested1.html', 'http://complex.com/nested1.html')
      success_page('/resources/nested2.html', 'http://complex.com/nested2.html')
    end

    it 'should parse data according to regexp' do
      crawl = RegexpCrawler::Crawler.new
      crawl.start_page = 'http://complex.com/'
      crawl.continue_regexp = %r{(?:http://complex.com)?/nested\d.html}
      crawl.capture_regexp = %r{<div class="title">(.*?)</div>.*<div class="date">(.*?)</div>.*<div class="body">(.*?)</div>}m
      crawl.named_captures = ['title', 'date', 'body']
      crawl.model = 'post'
      results = crawl.start
      results.size.should == 2
      results.first[:post][:title].should == 'nested1'
      results.last[:post][:title].should == 'nested2'
    end

    it 'should parse nested of nested data' do
      success_page('/resources/nested21.html', 'http://complex.com/nested21.html')
      crawl = RegexpCrawler::Crawler.new
      crawl.start_page = 'http://complex.com/'
      crawl.continue_regexp = %r{(?:http://complex.com)?/?nested\d+.html}
      crawl.capture_regexp = %r{<div class="title">(.*?)</div>.*<div class="date">(.*?)</div>.*<div class="body">(.*?)</div>}m
      crawl.named_captures = ['title', 'date', 'body']
      crawl.model = 'post'
      results = crawl.start
      results.size.should == 3
      results.first[:post][:title].should == 'nested1'
      results.last[:post][:title].should == 'nested21'
    end

    it "should save by myself" do
      crawl = RegexpCrawler::Crawler.new
      crawl.start_page = 'http://complex.com/'
      crawl.continue_regexp = %r{(?:http://complex.com)?/nested\d.html}
      crawl.capture_regexp = %r{<div class="title">(.*?)</div>.*<div class="date">(.*?)</div>.*<div class="body">(.*?)</div>}m
      crawl.named_captures = ['title', 'date', 'body']
      my_results = []
      crawl.save_method = Proc.new {|result, page| my_results << result}
      results = crawl.start
      results.size.should == 0
      my_results.size.should == 2
    end

    it "should stop parse" do
      crawl = RegexpCrawler::Crawler.new
      crawl.start_page = 'http://complex.com/'
      crawl.continue_regexp = %r{(?:http://complex.com)?/nested\d.html}
      crawl.capture_regexp = %r{<div class="title">(.*?)</div>.*<div class="date">(.*?)</div>.*<div class="body">(.*?)</div>}m
      crawl.named_captures = ['title', 'date', 'body']
      stop_page = "http://complex.com/nested1.html"
      parse_pages = []
      crawl.save_method = Proc.new do |result, page| 
        if page == stop_page
          false
        else
          parse_pages << page
        end
      end
      results = crawl.start
      parse_pages.size.should == 0
    end

    it 'should parse skip nested2.html' do
      success_page('/resources/nested21.html', 'http://complex.com/nested21.html')
      crawl = RegexpCrawler::Crawler.new
      crawl.start_page = 'http://complex.com/'
      crawl.continue_regexp = %r{(?:http://complex.com)?/?nested\d+.html}
      crawl.capture_regexp = %r{<div class="title">(.*?)</div>.*<div class="date">(.*?)</div>.*<div class="body">(.*?)</div>}m
      crawl.named_captures = ['title', 'date', 'body']
      crawl.model = 'post'
      crawl.need_parse = Proc.new do |page, response_body|
        if response_body.index('nested2 test html')
          false
        else
          true
        end
      end
      results = crawl.start
      results.size.should == 2
      results.first[:post][:title].should == 'nested1'
      results.last[:post][:title].should == 'nested21'
    end
  end

  def success_page(local_path, remote_path)
    path = File.expand_path(File.dirname(__FILE__) + local_path)
    content = File.read(path)
    http = mock(Net::HTTPSuccess)
    http.stubs(:is_a?).with(Net::HTTPSuccess).returns(true)
    http.stubs(:body).returns(content)
    Net::HTTP.expects(:get_response_with_headers).times(1).with(URI.parse(remote_path), nil).returns(http)
  end

  def redirect_page(remote_path, redirect_path)
    http = mock(Net::HTTPRedirection)
    http.stubs(:is_a?).with(Net::HTTPRedirection).returns(true)
    Net::HTTP.expects(:get_response_with_headers).times(1).with(URI.parse(remote_path), nil).returns(http)
  end
end
