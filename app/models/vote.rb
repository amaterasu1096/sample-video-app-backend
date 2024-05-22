class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :video

  enum vote_type: %w[upvote downvote]
  validates :vote_type, presence: true, inclusion: { in: vote_types.keys }
  validates :user_id, uniqueness: { scope: :video_id }
end
