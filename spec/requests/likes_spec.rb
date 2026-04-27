require "rails_helper"

RSpec.describe "Likes", type: :request do
  describe "POST /posts/:post_id/like" do
    it "creates a like" do
      user = create(:user)
      post_record = create(:post)
      sign_in user, scope: :user

      expect {
        post post_like_path(post_record)
      }.to change(Like, :count).by(1)
    end
  end

  describe "DELETE /posts/:post_id/like" do
    it "deletes a like" do
      user = create(:user)
      post_record = create(:post)
      create(:like, user: user, post: post_record)
      sign_in user, scope: :user

      expect {
        delete post_like_path(post_record)
      }.to change(Like, :count).by(-1)
    end
  end
end