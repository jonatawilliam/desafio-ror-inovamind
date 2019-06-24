class QuoteService
  def initialize(search_tag)
    @search_tag = search_tag
  end

  def execute
    search_quotes(@search_tag)
  end

  private 

  def search_quotes(search_tag)
    quotes_searched = []
    tags = Tag.search_title(search_tag).to_a.first
    if tags == nil
      quotes_crawled = WebCrawlerService.new(search_tag).execute
      database_save(quotes_crawled)
      quotes_searched = Quote.search_tag(Tag.search_title(search_tag).to_a.first.id) if Tag.search_title(search_tag).to_a.first
    else
      quotes_searched = Quote.search_tag(tags.id)
    end
    quotes_searched
  end

  def database_save(quotes_crawled)
    quotes_crawled.each do |item|
      tags = item["tags"]
      tags_collection = []
      tags.each do |tag|
        tags_collection << Tag.find_or_create_by!(title: tag)
      end
      author = Author.find_or_create_by!(
        name: item["author"]["name"],
        author_url: item["author"]["author_url"]
      )
      unless Quote.search_quote(item["quote"]).exists?
        quote_new = Quote.new(quote: item["quote"], tags: tags_collection, author: author)
        quote_new.save
      end
    end
  end
end