require "rails_helper"

RSpec.describe "Comments", type: :request do
  describe "POST /posts/:post_id/comments" do
    it "creates a comment" do
      user = create(:user)
      post_record = create(:post)
      sign_in user, scope: :user

      expect {
        post post_comments_path(post_record), params: {
          comment: {
            content: "テストコメント"
          }
        }
      }.to change(Comment, :count).by(1)

      expect(response).to have_http_status(:redirect).or have_http_status(:ok)
    end

    it "does not create a comment when content is blank" do
      user = create(:user)
      post_record = create(:post)
      sign_in user, scope: :user


      expect {
        post post_comments_path(post_record), params: {
          comment: {
            content: ""
          }
        }
      }.not_to change(Comment, :count)
    end
  end
end