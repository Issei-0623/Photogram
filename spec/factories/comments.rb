FactoryBot.define do
  factory :comment do
    association :user
    association :post
    content { "テストコメント" }
  end
end