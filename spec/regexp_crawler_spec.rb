require File.expand_path(File.dirname(__FILE__) + "/spec_helper.rb")

describe RegexpCrawler do
  class Post
    attr_accessor :title, :date, :body
  end
  
  describe '#simple html' do
    it 'should parse data according to regexp' do
      success_page('/resources/simple.html', 'http://simple.com/')

      crawl = RegexpCrawler.new
      crawl.start_page = 'http://simple.com/'
      crawl.capture_regexp = %r{<div class="title">(.*?)</div>.*<div class="date">(.*?)</div>.*<div class="body">(.*?)</div>}m
      crawl.named_captures = ['title', 'date', 'body']
      crawl.model = Post
      results = crawl.start
      results.size.should == 1
    end

    it 'should redirect' do
      redirect_page('http://redirect.com/', 'http://simple.com/')
      success_page('/resources/simple.html', 'http://simple.com/')
    end
  end

  describe '#complex html' do
    before(:each) do
      success_page('/resources/complex.html', 'http://complex.com/')
      success_page('/resources/nested1.html', 'http://complex.com/nested1.html')
      success_page('/resources/nested2.html', 'http://complex.com/nested2.html')
    end

    it 'should parse data according to regexp' do
      crawl = RegexpCrawler.new
      crawl.start_page = 'http://complex.com/'
      crawl.continue_regexp = %r{(?:http://complex.com/)?nested\d.html}
      crawl.capture_regexp = %r{<div class="title">(.*?)</div>.*<div class="date">(.*?)</div>.*<div class="body">(.*?)</div>}m
      crawl.named_captures = ['title', 'date', 'body']
      crawl.model = Post
      results = crawl.start
      results.size.should == 2
    end
  end

  def success_page(local_path, remote_path)
    path = File.expand_path(File.dirname(__FILE__) + local_path)
    content = File.read(path)
    http = mock(Net::HTTPSuccess)
    http.stubs(:is_a?).with(Net::HTTPSuccess).returns(true)
    http.stubs(:body).returns(content)
    Net::HTTP.expects(:get_response).times(1).with(URI.parse(remote_path)).returns(http)
  end

  def redirect_page(remote_path, redirect_path)
    http = mock(Net::HTTPRedirection)
    http.stubs(:is_a?).with(Net::HTTPRedirection).returns(true)
    Net::HTTP.expects(:get_response).times(1).with(URI.parse(remote_path)).returns(http)
  end
end
