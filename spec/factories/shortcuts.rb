FactoryBot.define do
  factory :shortcut do
    association :user
    title { "テストショートカット" }
    description { "" }
    download_url { "" }
    status { :draft }

    before(:create) do |shortcut|
      shortcut.send(:set_id)
    end

    trait :published_with_description do
      sequence(:description) { |n| "説明#{n}" }
      status { :published }
    end
  end
end
