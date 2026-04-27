require "rails_helper"

RSpec.describe Relationship, type: :model do
  describe "associations" do
    it "has follower and followed users" do
      relationship = build(:relationship)

      expect(relationship.follower).to be_present
      expect(relationship.followed).to be_present
    end
  end
end