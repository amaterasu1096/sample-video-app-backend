class Video < ApplicationRecord
  belongs_to :user
  has_many :votes, dependent: :destroy

  validates :title, presence: true
  validates :url, presence: true, format: { with: /\A(https?:\/\/)?(www\.)?((youtube\.com\/watch\?v=)|(v\/))([a-zA-Z0-9_\-]*)(\&\S+)?\z/i }
end
