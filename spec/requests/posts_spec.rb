require "rails_helper"

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "redirects to sign in page when user is not signed in" do
      get posts_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it "returns success when user is signed in" do
      user = create(:user)
      sign_in user

      get posts_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /posts/new" do
    it "returns success when user is signed in" do
      user = create(:user)
      sign_in user

      get new_post_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /posts" do
    it "creates a post when params are valid" do
      user = create(:user)
      sign_in user

      image = fixture_file_upload("test_image.png", "image/png")

      expect {
        post posts_path, params: {
          post: {
            content: "テスト投稿",
            images: [image]
          }
        }
      }.to change(Post, :count).by(1)

      expect(response).to redirect_to(posts_path)
    end

    it "does not create a post when content is blank" do
      user = create(:user)
      sign_in user

      image = fixture_file_upload("test_image.png", "image/png")

      expect {
        post posts_path, params: {
          post: {
            content: "",
            images: [image]
          }
        }
      }.not_to change(Post, :count)
    end
  end

  describe "GET /posts/:id" do
    it "returns success" do
      user = create(:user)
      post_record = create(:post, user: user)
      sign_in user

      get post_path(post_record)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /posts/:id" do
    it "updates own post" do
      user = create(:user)
      post_record = create(:post, user: user)
      sign_in user

      patch post_path(post_record), params: {
        post: {
          content: "更新後の本文"
        }
      }

      expect(response).to redirect_to(post_path(post_record))
      expect(post_record.reload.content).to eq("更新後の本文")
    end

    it "does not update another user's post" do
      user = create(:user)
      other_user = create(:user)
      post_record = create(:post, user: other_user)
      sign_in user

      patch post_path(post_record), params: {
        post: {
          content: "不正な更新"
        }
      }

      expect(response).to redirect_to(post_path(post_record))
      expect(post_record.reload.content).not_to eq("不正な更新")
    end
  end

  describe "DELETE /posts/:id" do
    it "deletes own post" do
      user = create(:user)
      post_record = create(:post, user: user)
      sign_in user

      expect {
        delete post_path(post_record)
      }.to change(Post, :count).by(-1)

      expect(response).to redirect_to(posts_path)
    end

    it "does not delete another user's post" do
      user = create(:user)
      other_user = create(:user)
      post_record = create(:post, user: other_user)
      sign_in user

      expect {
        delete post_path(post_record)
      }.not_to change(Post, :count)

      expect(response).to redirect_to(post_path(post_record))
    end
  end
end