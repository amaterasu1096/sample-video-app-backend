FactoryBot.define do
  factory :vote do
    association :user
    association :video
    vote_type { 'upvote' }

    trait :upvote do
      vote_type { 'upvote' }
    end

    trait :downvote do
      vote_type { 'downvote' }
    end
  end
end
