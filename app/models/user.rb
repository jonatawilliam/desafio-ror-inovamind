class User
  include ActiveModel::SecurePassword
  has_secure_password
  include Mongoid::Document
  field :name, type: String
  field :email, type: String
  field :password_digest, type: String
  validates :name, presence: :true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
end
