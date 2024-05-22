class User < ApplicationRecord
  has_many :videos, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password_digest, presence: true

  has_secure_password
end
