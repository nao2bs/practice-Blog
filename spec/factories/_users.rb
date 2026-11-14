# spec/factories/users.rb

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    admin { false }

    trait :admin do
      admin { true }
    end
  end

  factory :admin, parent: :user do
    sequence(:email) { |n| "admin#{n}@example.com" }
    admin { true }
  end
end
