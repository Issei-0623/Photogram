require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /users/:id" do
    it "returns success when user is signed in" do
      user = create(:user)
      sign_in user

      get user_path(user)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /users/:id" do
    it "updates own account_name" do
      user = create(:user, account_name: "before")
      sign_in user

      patch user_path(user), params: {
        user: {
          account_name: "after"
        }
      }

      expect(response).to redirect_to(user_path(user))
      expect(user.reload.account_name).to eq("after")
    end

    it "does not update another user" do
      user = create(:user)
      other_user = create(:user, account_name: "other")
      sign_in user

      patch user_path(other_user), params: {
        user: {
          account_name: "changed"
        }
      }

      expect(response).to redirect_to(user_path(other_user))
      expect(other_user.reload.account_name).to eq("other")
    end
  end

  describe "GET /users/:id/followers" do
    it "returns success" do
      user = create(:user)
      sign_in user

      get followers_user_path(user)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /users/:id/following" do
    it "returns success" do
      user = create(:user)
      sign_in user

      get following_user_path(user)

      expect(response).to have_http_status(:ok)
    end
  end
end