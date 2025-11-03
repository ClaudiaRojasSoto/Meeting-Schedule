FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    role { "member" }
    name { Faker::Name.name }

    trait :admin do
      role { "admin" }
    end
  end
end
