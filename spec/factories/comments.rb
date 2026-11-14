FactoryBot.define do
  factory :comment do
    content { 'Sample comment content' }
    association :post
  end
end
