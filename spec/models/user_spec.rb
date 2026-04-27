require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with account_name, email, and password" do
      user = build(:user)

      expect(user).to be_valid
    end

    it "is invalid without account_name" do
      user = build(:user, account_name: nil)

      expect(user).not_to be_valid
    end

    it "is invalid with duplicate account_name" do
      create(:user, account_name: "test_user")
      user = build(:user, account_name: "test_user")

      expect(user).not_to be_valid
    end
  end

  describe "#follow" do
    it "follows another user" do
      user = create(:user)
      other_user = create(:user)

      user.follow(other_user)

      expect(user.followings).to include(other_user)
    end

    it "does not follow itself" do
      user = create(:user)

      user.follow(user)

      expect(user.followings).not_to include(user)
    end
  end

  describe "#unfollow" do
    it "unfollows a user" do
      user = create(:user)
      other_user = create(:user)

      user.follow(other_user)
      user.unfollow(other_user)

      expect(user.followings).not_to include(other_user)
    end
  end
end