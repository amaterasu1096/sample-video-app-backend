class Video < ApplicationRecord
  belongs_to :user
  has_many :votes, dependent: :destroy
  has_many :upvotes, -> { where vote_type: :upvote }, foreign_key: :video_id, class_name: Vote.name
  has_many :downvotes, -> { where vote_type: :downvote }, foreign_key: :video_id, class_name: Vote.name

  validates :title, presence: true
  validates :url, presence: true, format: { with: /\A(https?:\/\/)?(www\.)?((youtube\.com\/watch\?v=)|(v\/))([a-zA-Z0-9_\-]*)(\&\S+)?\z/i }
end
