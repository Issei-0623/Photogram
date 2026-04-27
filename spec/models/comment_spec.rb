require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "validations" do
    it "is valid with content" do
      comment = build(:comment)

      expect(comment).to be_valid
    end

    it "is invalid without content" do
      comment = build(:comment, content: nil)

      expect(comment).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to a user and a post" do
      comment = build(:comment)

      expect(comment.user).to be_present
      expect(comment.post).to be_present
    end
  end
end