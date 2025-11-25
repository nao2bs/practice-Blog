FactoryBot.define do
  factory :post do
    title { 'Sample Post' }
    content { 'Sample content' }
    author { 'Author' }
    date { Date.today }
    association :category
  end
end
