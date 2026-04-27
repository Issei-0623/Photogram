require "rails_helper"

RSpec.describe "Posts", type: :system, js: true do
  it "creates a post" do
    user = create(:user)
    sign_in user, scope: :user

    visit new_post_path

    fill_in "post_content", with: "system specで投稿"

    attach_file "post_images",
                Rails.root.join("spec/fixtures/files/test_image.png"),
                make_visible: true

    expect(page).to have_content("test_image.png")

    click_button "Post"

    expect(page).to have_current_path(posts_path)
    expect(page).to have_content("system specで投稿")
  end
end