require "open-uri"
class String
  include CrawlerSample

  def crawler(&block)
    url=Url.new(:value=>self)
    raise "URL is invalid" unless url.valid?
    crawl(url.value) do|contents|
      block.call(contents) if block_given?
    end
  end
end


