require "crawler_sample/version"
require "nokogiri"
require "open-uri"
require 'kconv'
module CrawlerSample
  # Your code goes here...
  attr_accessor :top_url, :target_urls, :exclude_urls, :deep_flg, :delay, :stop_flg, :crawl_stop_count

  def crawl(url=nil)
    raise "URL is Blank" if url.nil?
    self.target_urls=[url]
    self.exclude_urls=[]
    target_scheme=URI.parse(url).scheme
    target_host=URI.parse(url).host
    error_cnt=0
    crawl_page_cnt=0
    self.crawl_stop_count = 1000 if self.crawl_stop_count.to_i <= 0
    loop do
     begin
      break if self.target_urls.empty? || self.stop_flg==true
      url =  self.target_urls.pop
      self.exclude_urls << url
      begin
        p "SuccessURL #{url}"
        site_contents = self.scrape(url)
        crawl_page_cnt += 1
      rescue
        p "ErrorURL #{url}"
      end
      site_contents.search("a").each do|anc|
        #ホスト名がtargetのホストと違う場合はクロール対象外にする
        begin; URI.parse(anc["href"]).host; rescue; next; end
        next unless anc["href"].scan(/\.(jpg|jpeg|png|gif|bmp|zip|exe|pdf|lzh)/i).empty?
        next if URI.parse(anc["href"]).host.present? && target_host!=URI.parse(anc["href"]).host
        anc["href"] = URI.parse(anc["href"]).path if URI.parse(anc["href"]).host.present?
        anc["href"] = anc["href"].gsub(/\/\.{1,2}/,"")
        anc["href"] = "/#{anc["href"]}" if anc["href"][0] != "/"
        self.target_urls << "#{target_scheme}://#{target_host}#{anc["href"]}".gsub(/\/\.{1,2}/,"")
        self.target_urls = (self.target_urls - self.exclude_urls).uniq
      end
      yield site_contents
     rescue => e
      error_cnt +=1
      p "error #{error_cnt} #{e}"
      next
     end
     crawl_is_force_stop if error_cnt > 200 || crawl_page_cnt > self.crawl_stop_count
    end
  end

  def crawl_is_force_stop
    self.stop_flg=true
  end

  def crawl_from_url(url=nil)
    raise "URL is Blank" if url.nil?
    site_contents = self.scrape(url)
    return if site_contents.nil?
    yield site_contents
  end

  def crawl_delay=(delay=nil)
    self.delay= delay.nil? ? 1 : delay
  end

  def crawl_delay
    return self.delay.blank? ? 1 : self.delay
  end

  def scrape(url, option={})
    #self.delay = option[:delay].present? ? option[:delay] : 1
    sleep self.crawl_delay #delay
    html=open(url,"r:binary","User-Agent"=>"Blue Field 0.5.0.1" ).read
    return  Nokogiri::HTML(html.toutf8, nil, 'utf-8')
  rescue
    raise FaildScrape
  end
end
