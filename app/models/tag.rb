class Tag
  include Mongoid::Document
  field :title, type: String
  validates :title, presence: { message: 'Não pode ser deixado em branco o titúlo da tag' }
  has_and_belongs_to_many :quotes
  scope :search_title, -> (title) { where(title: title) }
end
