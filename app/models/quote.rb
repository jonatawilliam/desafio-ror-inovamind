class Quote
  include Mongoid::Document
  field :quote, type: String
  validates :quote, presence: { message: 'Não pode ser deixado em branco a citação' }
  belongs_to :author
  has_many :tags
end
