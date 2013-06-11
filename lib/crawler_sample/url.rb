require "open-uri"
class String
  include CrawlSample

  def crawler
    url=Url.new(:value=>self)
    raise "URL is invalid" unless url.valid?
    crawl(url.value).each do|contents|
      yield
    end
  end
end

class Url
  attr_accessor :scheme, :host, :value
  def initialize(values = {})
    values.each do |k, v|
      self.send("#{k}=", v)
    end
  end

  def valid?
    begin
      uri = URI.parse(self.value)
      resp = uri.kind_of?(URI::HTTP)
      return resp
    rescue URI::InvalidURIError
      return false
    end
  end

end
