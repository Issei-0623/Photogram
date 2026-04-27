require "rails_helper"

RSpec.describe "Relationships", type: :request do
  describe "POST /relationships" do
    it "follows a user" do
      user = create(:user)
      other_user = create(:user)
      sign_in user

      expect {
        post relationships_path, params: {
          user_id: other_user.id
        }
      }.to change(Relationship, :count).by(1)

      expect(response).to redirect_to(user_path(other_user))
    end
  end

  describe "DELETE /relationships/:id" do
    it "unfollows a user" do
      user = create(:user)
      other_user = create(:user)
      relationship = create(:relationship, follower: user, followed: other_user)
      sign_in user

      expect {
        delete relationship_path(relationship)
      }.to change(Relationship, :count).by(-1)

      expect(response).to redirect_to(user_path(other_user))
    end
  end
end