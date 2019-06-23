class Tag
  include Mongoid::Document
  field :title, type: String
  validates :title, presence: { message: 'Não pode ser deixado em branco o titúlo da tag' }
  has_many :quotes
end
