require "open-uri"
class String
  include CrawlerSample

  def crawler
    url=Url.new(:value=>self)
    raise "URL is invalid" unless url.valid?
    crawl(url.value).each do|contents|
      yield
    end
  end
end


