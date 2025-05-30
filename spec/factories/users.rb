FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    uid { SecureRandom.base36 }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    confirmed_at { Time.current }
    provider { nil }
    credits { 150 }

    trait :with_google_auth do
      provider { "google_oauth2" }
      uid { SecureRandom.base36 }
    end

    trait :with_avatar do
      after(:build) do |user|
        user.avatar.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/sample-avatar.png")),
          filename: "sample-avatar.png",
          content_type: "image/png"
        )
      end
    end
  end
end
