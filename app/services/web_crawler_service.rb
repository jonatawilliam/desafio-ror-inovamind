class WebCrawlerService
  require 'open-uri'
  def initialize(search_tag)
    @search_tag_not_strip = search_tag
    @url = "http://quotes.toscrape.com"
  end

  def execute
    tag_strip(@search_tag_not_strip)
    web_crawler
  end

  private 
  
  def tag_strip(search_tag)
    search_tag.strip.size == 0 ? @search_tag = [] : @search_tag = search_tag.strip
  end

  def web_crawler
    crawler = Nokogiri::HTML(open(@url + '/tag/' + @search_tag))   
    quotes_crawled = []
    html_elements = crawler.css('div.quote')
    html_elements.each do |element|
      item = {}
      item['quote'] = element.css('span.text').inner_html
      tags = element.css('meta.keywords')[0].attributes['content'].value
      item['tags'] = @search_tag.split ','
      author_url = element.css('small.author')[0].next_element
      author_url = author_url.attributes["href"].value
      item['author'] = {
        'name' => element.css('small.author').inner_html,
        'author_url' => "#{@url}#{author_url}"
      }
      quotes_crawled << item
    end
    quotes_crawled            
  end
end
