require "rails_helper"

RSpec.describe Like, type: :model do
  describe "validations" do
    it "is valid with user and post" do
      like = build(:like)

      expect(like).to be_valid
    end

    it "is invalid when the same user likes the same post twice" do
      user = create(:user)
      post = create(:post)

      create(:like, user: user, post: post)
      duplicate_like = build(:like, user: user, post: post)

      expect(duplicate_like).not_to be_valid
    end
  end
end