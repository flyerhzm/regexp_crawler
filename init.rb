if defined?(ActiveRecord)
  ActiveRecord::Base.send :include, RegexpCrawler
end
