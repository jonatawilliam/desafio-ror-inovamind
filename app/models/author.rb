class Author
  include Mongoid::Document
  field :name, type: String
  field :author_url, type: String
  validates :name, presence: { message: 'Não pode ser deixado em branco o nome do autor(a)' }
  has_many :quotes
end
