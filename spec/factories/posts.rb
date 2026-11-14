FactoryBot.define do
  factory :post do
    title { 'Sample Post' }
    content { 'Sample content' }
    author { 'Author' }
    date { Date.today }
    association :category
    status { :draft }

    trait :draft do
      status { :draft }
    end

    trait :published do
      status { :published }
    end
  end
end
