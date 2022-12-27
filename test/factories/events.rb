FactoryBot.define do
  factory :event do
    owner
    sequence(:name) { |i| "イベント名#{i}"}
    sequence(:place) { |i| "イベント開催場所#{i}"}
    sequence(:content) { |i| "イベント本文#{i}"}
    start_at { 1.days.from_now }
    end_at { 1.days.from_now + rand(1..30).hours }

    trait :invalid do
      name { nil }
    end
  end
end
