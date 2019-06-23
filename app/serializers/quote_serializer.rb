class QuoteSerializer < ActiveModel::Serializer
  attribute  :quote, key: :quote

  def attributes(*attrs)
    quote = super(*attrs)
    quote[:author] = object.author.name
    quote[:author_about] = object.author.author_url
    quote[:tags] = object.tags.map { |tag| tag.title }
    quote
  end
end
