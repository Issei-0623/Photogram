require "rails_helper"

RSpec.describe Post, type: :model do
  describe "validations" do
    it "is valid with content and images" do
      post = build(:post)

      expect(post).to be_valid
    end

    it "is invalid without content" do
      post = build(:post, content: nil)

      expect(post).not_to be_valid
    end

    it "is invalid without images" do
      post = build(:post)
      post.images.detach

      expect(post).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to a user" do
      post = build(:post)

      expect(post.user).to be_present
    end
  end
end