require "rails_helper"

RSpec.describe "Likes", type: :system, js: true do
  it "likes a post" do
    user = create(:user)
    post_record = create(:post)

    sign_in user, scope: :user

    visit post_path(post_record)

    expect {
      find(".like-button").click
      expect(page).to have_css("img[src*='heart-active']")
    }.to change(Like, :count).by(1)
  end
end