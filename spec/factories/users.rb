FactoryBot.define do
    factory :user do
      sequence(:name) { |n| "firsthit#{n}" }
      sequence(:email) { |n| "user#{n}@example.com" }
      password { "password" }
      password_confirmation { "password" }
    end
  end
