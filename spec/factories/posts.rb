FactoryBot.define do
  factory :post do
    association :user
    content { "テスト投稿" }

    after(:build) do |post|
      post.images.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/test_image.png")),
        filename: "test_image.png",
        content_type: "image/png"
      )
    end
  end
end