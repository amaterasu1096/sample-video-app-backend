FactoryBot.define do
  factory :video do
    association :user
    title { Faker::Lorem.sentence }
    url { Faker::Internet.url(host: 'www.youtube.com', path: '/watch?v=') + Faker::Internet.uuid }
  end
end
