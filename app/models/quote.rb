class Quote
  include Mongoid::Document
  field :quote, type: String
  validates :quote, presence: { message: 'Não pode ser deixado em branco a citação' }
  belongs_to :author
  has_and_belongs_to_many :tags
  scope :search_quote, -> (quote) { where(quote: quote) }
  scope :search_tag, -> (tags) { where(tag_ids: tags) }
end
